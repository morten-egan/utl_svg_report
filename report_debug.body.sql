create or replace package body report_debug

as

	procedure dump_page_debug_to_screen (
		page_in			in		report_page.page
	)

	as

		area_idx		varchar2(4000);

	begin

		dbms_output.put_line('************************ START DUMP OF REPORT PAGE ************************');
		dbms_output.put_line('Page id .....................: '|| page_in.page_id);
		dbms_output.put_line('Page name ...................: '|| page_in.attributes.page_name);
		dbms_output.put_line('Page size(bytes) ............: '|| page_in.page_size);
		dbms_output.put_line('Page start ..................: '|| page_in.page_start);
		dbms_output.put_line('Page end ....................: '|| page_in.page_end);
		area_idx := page_in.areas.first;
		while area_idx is not null loop
			dbms_output.put_line('----> Area ..........: ' || page_in.areas(area_idx).area_name);
			dbms_output.put_line('      Area data .....: ' || page_in.areas(area_idx).area_data);
			dbms_output.put_line('      Area curr x ...: ' || page_in.areas(area_idx).track.current_x);
			dbms_output.put_line('      Area curr y ...: ' || page_in.areas(area_idx).track.current_y);
			area_idx := page_in.areas.next(area_idx);
		end loop;

	end dump_page_debug_to_screen;

	procedure dump_page_to_screen (
		page_in			in		report_page.page
	)

	as

		area_idx		varchar2(4000);

	begin

		dbms_output.put_line(page_in.page_start);

		-- Write defs to page
		dbms_output.put_line('<defs>');
		area_idx := page_in.defs.first;
		while area_idx is not null loop
			dbms_output.put_line(page_in.defs(area_idx).def_data);
			area_idx := page_in.defs.next(area_idx);
		end loop;
		dbms_output.put_line('</defs>');

		-- Write areas of the page
		area_idx := page_in.areas.first;
		while area_idx is not null loop
			dbms_output.put_line(page_in.areas(area_idx).area_data);
			area_idx := page_in.areas.next(area_idx);
		end loop;
		dbms_output.put_line(page_in.page_end);

	end dump_page_to_screen;

end report_debug;
/
