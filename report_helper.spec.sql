create or replace package report_helper

as

	function mm_text_length (
		text_in			in		varchar2,
		font_in			in		varchar2,
		font_size		in		number
	)
	return number;

	procedure calculate_font_track_movement (
		text_in			in		varchar2,
		font_name		in		varchar2,
		font_size		in		number,
		move_x			out		number,
		move_y			out		number,
		new_line		in		boolean default true
	);

	function font_size_to_mm (
		font_size_in	in		number
	)
	return number;

end report_helper;
/
