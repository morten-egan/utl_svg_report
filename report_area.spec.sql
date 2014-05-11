create or replace package report_area

as

	procedure area_reset_x (
		page_in				in out	report_page.page,
		area_in				in		varchar2
	);

	procedure area_reset_y (
		page_in				in out	report_page.page,
		area_in				in		varchar2
	);

	procedure area_move_x (
		page_in				in out	report_page.page,
		area_in				in		varchar2,
		move				in		number,
		move_type			in		varchar2 default 'unit_type'
	);

	procedure area_move_y (
		page_in				in out	report_page.page,
		area_in				in		varchar2,
		move				in		number,
		move_type			in		varchar2 default 'unit_type'
	);

	procedure area_set_font (
		page_in				in out	report_page.page,
		area_in				in		varchar2,
		font_in				in		varchar2 default null,
		font_size_in		in		number default null,
		font_weight_in		in		varchar2 default null,
		font_color_in		in		varchar2 default null,
		font_orientation_in	in		varchar2 default null
	);

	procedure area_set_alignment (
		page_in				in out	report_page.page,
		area_in				in		varchar2,
		aligment_in			in		varchar2
	);

	procedure add_to_position (
		page_in				in out	report_page.page,
		area_in				in		varchar2 default null,
		add_to_x			in		number default null,
		add_to_y			in		number default null
	);

end report_area;
/