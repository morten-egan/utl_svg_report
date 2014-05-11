create or replace package body report_helper

as

	procedure calculate_font_track_movement (
		text_in			in		varchar2,
		font_name		in		varchar2,
		font_size		in		number,
		move_x			out		number,
		move_y			out		number,
		new_line		in		boolean default true
	)

	as

	begin

		if new_line then
			move_x := 0;
			move_y := font_size * 0.284583;
		else
			move_x := round(mm_text_length(text_in, font_name, font_size),4);
			move_y := 0;
		end if;

	end calculate_font_track_movement;

	function font_size_to_mm (
		font_size_in		in		number
	)
	return number

	as

	begin

		return round(font_size_in * 0.264583,2);

	end font_size_to_mm;

	function mm_text_length (
		text_in			in		varchar2,
		font_in			in		varchar2,
		font_size		in		number
	)
	return number

	as

		-- Approximated aspect ratios
		--
		-- Andale Mono			0.44
		-- Courier new			0.50
		-- Arial			0.24

		font_up				varchar2(250) := upper(font_in);
		aspect_ratio			number;
		single_character_width		number;
		text_length_points		number;
		text_length_inches		number;
		text_length_mm			number;

	begin

		if font_up = 'ARIAL' then
			aspect_ratio := 0.42;
		elsif font_up = 'COURIER NEW' then
			aspect_ratio := 0.50;
		elsif font_up = 'ANDALE MONO' then
			aspect_ratio := 0.44;
		end if;

		single_character_width := font_size * aspect_ratio;
		text_length_points := length(text_in) * single_character_width;
		text_length_inches := text_length_points/72;
		text_length_mm := text_length_inches * 25.4;

		return text_length_mm;

	end mm_text_length;

end report_helper;
/
