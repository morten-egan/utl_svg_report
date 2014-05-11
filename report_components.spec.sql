create or replace package report_components

as

	type polyline_points is table of number index by pls_integer;

	function polyline (
		polypoints			in		polyline_points,
		line_color			in		varchar2 default report_defaults.def_color_line,
		line_width			in		varchar2 default report_defaults.def_size_line_width
	)
	return clob;

	procedure page_polyline (
		page_in				in out	report_page.page,
		area_name			in		varchar2 default null,
		polypoints			in		polyline_points,
		line_color			in		varchar2 default report_defaults.def_color_line,
		line_width			in		varchar2 default report_defaults.def_size_line_width
	);

	procedure report_polyline (
		report_object		in out	report_create.report,
		area_name			in		varchar2 default null,
		polypoints			in		polyline_points,
		line_color			in		varchar2 default report_defaults.def_color_line,
		line_width			in		varchar2 default report_defaults.def_size_line_width
	);

	procedure page_text (
		page_in				in out	report_page.page,
		text_in				in		varchar2,
		area_name			in		varchar2 default null,
		new_line			in		boolean default true,
		text_filter			in		varchar2 default null,
		text_rotate			in		varchar2 default null
	);

	procedure wrapped_page_text (
		page_in				in out	report_page.page,
		text_in				in		varchar2,
		area_name			in		varchar2 default null
	);

	procedure report_text (
		report_object		in out	report_create.report,
		text_in				in		varchar2,
		area_idx			in		varchar2 default null,
		new_line			in		boolean default true,
		text_filter			in		varchar2 default null,
		text_rotate			in		varchar2 default null
	);

	function text_object (
		text_in				in		varchar2,
		x_in				in		number,
		y_in				in		number,
		unit_type			in		varchar2,
		font_family			in		varchar2,
		font_size			in		number,
		font_weight			in		varchar2,
		font_color			in		varchar2,
		text_align			in		varchar2,
		text_filter			in		varchar2 default null,
		font_orientation	in		varchar2 default null,
		text_rotate			in		varchar2 default null
	)
	return clob;

	procedure page_textbox (
		page_in				in out	report_page.page,
		text_in				in		varchar2,
		area_name			in		varchar2 default null,
		text_color			in		varchar2 default null
	);

	procedure report_textbox (
		report_object		in out	report_create.report,
		text_in				in		varchar2,
		area_idx			in		varchar2 default null,
		text_color			in		varchar2 default null
	);

	function text_box (
		box_text_in				in		varchar2,
		x_in					in		number,
		y_in					in		number,
		unit_type				in		varchar2,
		font_family				in		varchar2,
		font_size				in		number,
		font_weight				in		varchar2,
		font_color				in		varchar2,
		box_border_width		in		number default report_defaults.def_size_border_width,
		box_border_color		in		varchar2 default report_defaults.def_color_border,
		box_fill_color			in		varchar2 default report_defaults.def_color_fill,
		box_padding				in		number default report_defaults.def_size_box_padding,
		box_corner_rounding		in		number default report_defaults.def_size_corner_rounding,
		box_match_width_to_text	in		boolean default true,
		box_width_in			in		number default null,
		justify_right			in		boolean default false,
		box_filter				in		varchar2 default null,
		box_text_filter			in		varchar2 default null
	)
	return clob;

	function line (
		x1_in				in		number,
		x2_in				in		number,
		y1_in				in		number,
		y2_in				in		number,
		unit_type			in		varchar2,
		line_color			in		varchar2,
		line_width			in		varchar2
	)
	return clob;

	procedure page_line (
		page_in				in out	report_page.page,
		line_type			in		varchar2,
		line_type_val		in		number default null,
		area_name			in		varchar2 default null
	);

	procedure report_line (
		report_object		in out	report_create.report,
		line_type			in		varchar2,
		line_type_val		in		number default null,
		area_idx			in		varchar2 default null
	);

	function rect (
		x_in				in		number,
		y_in				in		number,
		unit_type			in		varchar2,
		height_in			in		number,
		width_in			in		number,
		rect_fill			in		varchar2,
		rect_filter			in		varchar2 default null,
		rect_title			in		varchar2 default null
	)
	return clob;

	procedure page_rect (
		page_in				in out	report_page.page,
		area_name			in		varchar2 default null,
		rect_type			in		varchar2,
		rect_length			in		number,
		rect_height			in		number,
		rect_fill			in		varchar2 default report_defaults.def_color_fill,
		rect_filter			in		varchar2 default null,
		rect_title			in		varchar2 default null
	);

	procedure report_rect (
		report_object		in out	report_create.report,
		area_name			in		varchar2 default null,
		rect_type			in		varchar2,
		rect_length			in		number,
		rect_height			in		number,
		rect_fill			in		varchar2 default report_defaults.def_color_fill,
		rect_filter			in		varchar2 default null,
		rect_title			in		varchar2 default null
	);

	function circle (
		x_in				in		number,
		y_in				in		number,
		unit_type			in		varchar2,
		circle_radius		in		number,
		circle_stroke		in		number,
		circle_stroke_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill			in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	)
	return clob;

	procedure page_circle (
		page_in				in out	report_page.page,
		area_name			in		varchar2 default null,
		circle_size			in		number,
		circle_line_size	in		number,
		circle_line_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill			in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	);

	procedure report_circle (
		report_object		in out	report_create.report,
		area_name			in		varchar2 default null,
		circle_size			in		number,
		circle_line_size	in		number,
		circle_line_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill			in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	);

end report_components;
/
