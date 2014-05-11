create or replace package body report_create

as

	procedure new_report (
		report_object		in out		report,
		name_in			in		varchar2,
		description_in		in		varchar2
	)

	as

		rep_id			number;

	begin

		select
			gen_seq.nextval
		into
			rep_id
		from
			dual;

		execute immediate 'alter session set NLS_NUMERIC_CHARACTERS= ''.,''';

		report_object.report_id := rep_id;
		report_object.report_name := name_in;
		report_object.report_description := description_in;
		report_object.attributes.page_tracking := report_default_tracking;
		report_object.attributes.page_header := report_default_header;
		report_object.attributes.page_footer := report_default_footer;
		report_object.attributes.page_numbers := report_default_pagenumber;
		report_object.attributes.page_type := report_default_pagetype;
		report_object.attributes.page_orientation := report_default_orientation;
		report_object.attributes.page_svgs_created := 0;

		if report_default_pagenumber = 1 then
			report_object.keywords('TOTAL_PAGECOUNT') := '0';
		end if;

	end new_report;

	procedure set_keyword (
		report_object		in out		report,
		keyword			in		varchar2,
		value			in		varchar2
	)

	as

	begin

		report_object.keywords(keyword) := value;

	end set_keyword;

	procedure set_attribute (
		report_object		in out		report,
		attribute_name		in		varchar2,
		attribute_value		in		varchar2
	)

	as

	begin

		if attribute_name = 'header' then
			report_object.attributes.page_header := attribute_value;
		elsif attribute_name = 'footer' then
			report_object.attributes.page_footer := attribute_value;
		elsif attribute_name = 'pagenumber' then
			if attribute_value = 1 then
				report_object.keywords('TOTAL_PAGECOUNT') := '0';
			else
				report_object.keywords.delete('TOTAL_PAGECOUNT');
			end if;
			report_object.attributes.page_numbers := attribute_value;
		elsif attribute_name = 'tracking' then
			report_object.attributes.page_tracking := attribute_value;
		elsif attribute_name = 'pagetype' then
			report_object.attributes.page_type := attribute_value;
		elsif attribute_name = 'orientation' then
			report_object.attributes.page_orientation := attribute_value;
		end if;

	end set_attribute;

	procedure new_report_page (
		report_object		in out		report,
		page_name		in		varchar2 default null,
		page_template		in		varchar2 default null
	)

	as

		page_id			number := 1;

	begin

		-- Make sure that page defaults corresponds to report settings
		report_page.pd_tracking := report_object.attributes.page_tracking;
		report_page.pd_header := report_object.attributes.page_header;
		report_page.pd_footer := report_object.attributes.page_footer;

		if report_object.report_pages.exists(1) then
			page_id := report_object.report_pages.last + 1;
		end if;

		report_object.report_pages(page_id) := report_page.iso_page(report_object.attributes.page_type, report_object.attributes.page_orientation, page_template);
		if report_object.attributes.page_numbers = 1 then
			-- Increment total page count
			report_object.keywords('TOTAL_PAGECOUNT') := report_object.keywords('TOTAL_PAGECOUNT') + 1;
			-- Set the pagenumber of the created page
			report_object.report_pages(page_id).attributes.pagenumber := report_object.keywords('TOTAL_PAGECOUNT');
		end if;

		if page_name is not null then
			report_object.report_pages(page_id).attributes.page_name := page_name;
		end if;

		report_object.report_current_page := page_id;

	end new_report_page;

	procedure set_page_by_name (
		report_object		in out		report,
		page_name_in		in		varchar2
	)

	as

		page_idx		number;

	begin

		page_idx := report_object.report_pages.first;
		while page_idx is not null loop
			if report_object.report_pages(page_idx).attributes.page_name = page_name_in then
				set_page_by_num(report_object, page_idx);
				page_idx := null;
			else
				page_idx := report_object.report_pages.next(page_idx);
			end if;
		end loop;

	end set_page_by_name;

	procedure set_page_by_num (
		report_object		in out		report,
		page_num_in		in		number
	)

	as

	begin

		report_object.report_current_page := page_num_in;

	end set_page_by_num;

	procedure report_page_keyword_replace (
		report_object		in out		report,
		page_idx_in		in		number
	)

	as

		keyword_idx		varchar2(200);

	begin

		keyword_idx := report_object.keywords.first;
		while keyword_idx is not null loop
			report_page.page_data_replace(report_object.report_pages(page_idx_in), '#' || keyword_idx ||'#', report_object.keywords(keyword_idx));
			keyword_idx := report_object.keywords.next(keyword_idx);
		end loop;

		if report_object.attributes.page_numbers = 1 then
			report_page.page_data_replace(report_object.report_pages(page_idx_in), '#PAGENUMBER#', to_char(report_object.report_pages(page_idx_in).attributes.pagenumber));
		end if;

	end report_page_keyword_replace;

	procedure report_pages_to_files (
		report_object		in out		report
	)

	as

		page_idx		number;
		page_sort_out		varchar2(10);
		file_name		varchar2(500);

	begin

		page_idx := report_object.report_pages.first;
		while page_idx is not null loop
			/* We should replace keywords before writing to page */
			report_page_keyword_replace(report_object, page_idx);

			if report_object.attributes.page_numbers = 1 then
				page_sort_out := to_char(report_object.report_pages(page_idx).attributes.pagenumber);
			else
				page_sort_out := to_char(page_idx);
			end if;

			if length(page_sort_out) <= 2 then
				page_sort_out := lpad(page_sort_out,3,'0');
			end if;

			file_name := to_char(report_object.report_id) || '_' || page_sort_out || '.svg';

			report_page.page_to_file(report_object.report_pages(page_idx), file_name);

			-- Set next and reset data
			page_idx := report_object.report_pages.next(page_idx);
		end loop;

		report_object.attributes.page_svgs_created := 1;

	end report_pages_to_files;

	procedure report_pagefiles_to_pdf (
		report_object		in out		report,
		pdf_created		out		boolean,
		pdf_name		out		varchar2
	)

	as

		job_name		varchar2(200) := 'rep_j_' || to_char(report_object.report_id);
		page_count		varchar2(10);
		file_name		varchar2(200) := 'dbrep_'|| to_char(report_object.report_id) ||'.pdf';

		-- The exists vars
		fexists			boolean := false;
		flength			number;
		bsize			number;

	begin

		if report_object.attributes.page_svgs_created = 0 then
			-- SVGS has not been created yet, so "to pdf" will fail. Make sure that they are there before we create pdf.
			report_pages_to_files(report_object);
		end if;

		if report_object.attributes.page_numbers = 1 then
			page_count := to_char(report_object.keywords('TOTAL_PAGECOUNT'));
		else
			page_count := to_char(report_object.report_pages.last);
		end if;

		dbms_scheduler.create_job (
			job_name => job_name
			, program_name => 'CONVERT_REP_TO_PDF'
			, enabled => false
		);
		dbms_scheduler.set_job_argument_value(
			job_name => job_name
			, argument_position => 4
			, argument_value => to_char(report_object.report_id)
		);
		dbms_scheduler.set_job_argument_value(
			job_name => job_name
			, argument_position => 5
			, argument_value => page_count
		);
		dbms_scheduler.enable(job_name);

		while fexists = false loop
			utl_file.fgetattr('REPORT_OUT', file_name, fexists, flength, bsize);
			dbms_lock.sleep(3);
		end loop;

		pdf_created := fexists;
		pdf_name := file_name;

		exception
			when others then
				pdf_created := false;

	end report_pagefiles_to_pdf;

end report_create;
/
