create or replace package report_page

as

	-- Page defaults
	pd_tracking			number 			:= 1;
	pd_header			number 			:= 0;
	pd_footer			number 			:= 0;
	pd_font				varchar2(200) 	:= 'Courier New';
	pd_font_size		number 			:= 12;
	pd_font_weight		varchar2(200) 	:= 'normal';
	pd_font_color		varchar2(200) 	:= '#000000';

	type page_dimension is record (
		page_width		number,
		page_height		number
	);

	type tracker is record (
		current_x		number,
		current_y		number
	);

	type page_fixed is record (
		fixed_type		varchar2(200),
		fixed_x1		number,
		fixed_x2		number,
		fixed_y1		number,
		fixed_y2		number,
		fixed_data		clob
	);

	type page_attributes is record (
		orientation		varchar2(200),
		unit_type		varchar2(200),
		pagenumber		number,
		page_name		varchar2(4000),
		has_header		number,
		has_footer		number,
		is_tracked		number,
		track			tracker
	);

	type page_area is record (
		start_x					number,
		start_y					number,
		end_x					number,
		end_y					number,
		area#					number,
		area_name				varchar2(200),
		area_font				varchar2(200),
		area_font_size			number,
		area_font_weight		varchar2(200),
		area_font_color			varchar2(200),
		area_font_orientation	varchar2(200),
		area_alignment			varchar2(200),
		area_data				clob,
		is_tracked				number,
		track					tracker
	);

	type page_areas is table of page_area index by varchar2(200);

	type page_def is record (
		def_data		clob
	);

	type page_defs is table of page_def index by varchar2(4000);

	type page is record (
		page_id			number,
		page_size		number,
		page_start		clob,
		page_end		clob,
		page_header		page_fixed,
		page_footer		page_fixed,
		dimensions		page_dimension,
		attributes		page_attributes,
		areas			page_areas,
		defs			page_defs
	);

	type pages is table of page index by pls_integer;

	function iso_page (
		iso_name_in			in		varchar2 default 'A4',
		orientation_in		in		varchar2 default 'portrait',
		template_in			in		varchar2 default null
	)
	return page;

	function make_page (
		width_in			in		number,
		height_in			in		number,
		unit_in				in		varchar2 default 'mm',
		orientation_in		in		varchar2 default 'portrait',
		template_in			in		varchar2 default null
	)
	return page;

	procedure set_attribute (
		page_in				in out	page,
		attribute_name		in		varchar2,
		attribute_value		in		varchar2
	);

	procedure add_page_track (
		page_in				in out	page,
		add_to_x			in		number,
		add_to_y			in		number
	);

	procedure add_area_track (
		page_in				in out	page,
		area_in				in		varchar2,
		add_to_x			in		number,
		add_to_y			in		number
	);

	procedure page_size_update (
		page_in				in out	page
	);

	procedure page_to_file (
		page_in				in		page,
		file_name_in		in		varchar2 default null
	);

	procedure page_data_replace (
		page_in				in out	page,
		replace_what		in		varchar2,
		replace_with		in		varchar2
	);

end report_page;
/
