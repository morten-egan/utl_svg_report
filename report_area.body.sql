create or replace package body report_area 

as

	procedure area_reset_x (
		page_in			in out		report_page.page,
		area_in			in		varchar2
	)

	as

	begin

		page_in.areas(area_in).track.current_x := page_in.areas(area_in).start_x;

	end area_reset_x;

	procedure area_reset_y (
		page_in			in out		report_page.page,
		area_in			in		varchar2
	)

	as

	begin

		page_in.areas(area_in).track.current_y := page_in.areas(area_in).start_y;

	end area_reset_y;

	procedure area_move_x (
		page_in			in out		report_page.page,
		area_in			in		varchar2,
		move			in		number,
		move_type		in		varchar2 default 'unit_type'
	)

	as

	begin

		if move_type = 'unit_type' then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).track.current_x + move;
		elsif move_type = 'unit_type_to' then
			page_in.areas(area_in).track.current_x := move;
		elsif move_type = 'pct' then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).track.current_x + (((page_in.areas(area_in).end_x - page_in.areas(area_in).start_x)/100) * move);
		elsif move_type = 'pct_to' then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).start_x + (((page_in.areas(area_in).end_x - page_in.areas(area_in).start_x)/100) * move);
		elsif move_type = 'end' then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).end_x;
		elsif move_type = 'start' then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).start_x;
		end if;

	end area_move_x;

	procedure area_move_y (
		page_in			in out		report_page.page,
		area_in			in		varchar2,
		move			in		number,
		move_type		in		varchar2 default 'unit_type'
	)

	as

	begin

		if move_type = 'unit_type' then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).track.current_y + move;
		elsif move_type = 'unit_type_to' then
			page_in.areas(area_in).track.current_y := move;
		elsif move_type = 'pct' then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).track.current_y + (((page_in.areas(area_in).end_y - page_in.areas(area_in).start_y)/100) * move);
		elsif move_type = 'pct_to' then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).start_y + (((page_in.areas(area_in).end_y - page_in.areas(area_in).start_y)/100) * move);
		elsif move_type = 'end' then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).end_y;
		elsif move_type = 'start' then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).start_y;
		end if;

	end area_move_y;

	procedure area_set_font (
		page_in			in out		report_page.page,
		area_in			in		varchar2,
		font_in			in		varchar2 default null,
		font_size_in		in		number default null,
		font_weight_in		in		varchar2 default null,
		font_color_in		in		varchar2 default null,
		font_orientation_in	in		varchar2 default null
	)

	as

	begin

		if font_in is not null then
			page_in.areas(area_in).area_font := font_in;
		end if;

		if font_size_in is not null then
			page_in.areas(area_in).area_font_size := font_size_in;
		end if;

		if font_weight_in is not null then
			page_in.areas(area_in).area_font_weight := font_weight_in;
		end if;

		if font_color_in is not null then
			page_in.areas(area_in).area_font_color := font_color_in;
		end if;

		if font_orientation_in is not null then
			page_in.areas(area_in).area_font_orientation := font_orientation_in;
		end if;

	end area_set_font;

	procedure area_set_alignment (
		page_in			in out		report_page.page,
		area_in			in		varchar2,
		aligment_in		in		varchar2
	)

	as

	begin

		page_in.areas(area_in).area_alignment := lower(aligment_in);

	end area_set_alignment;

	procedure add_to_position (
		page_in			in out		report_page.page,
		area_in			in		varchar2 default null,
		add_to_x		in		number default null,
		add_to_y		in		number default null
	)

	as

		area_idx		varchar2(200) := 'M0';

	begin

		if area_in is not null then
			area_idx := area_in;
		end if;

		if add_to_x is not null then
			page_in.areas(area_in).track.current_x := page_in.areas(area_in).track.current_x + add_to_x;
		end if;

		if add_to_y is not null then
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).track.current_y + add_to_y;
		end if;

	end add_to_position;

end report_area;
/
