create or replace package body report_components

as

	function polyline (
		polypoints		in		polyline_points,
		line_color		in		varchar2 default report_defaults.def_color_line,
		line_width		in		varchar2 default report_defaults.def_size_line_width
	)
	return clob

	as

		point_idx		number;
		polyline_data		clob;

	begin

		polyline_data := '<polyline points="';

		point_idx := polypoints.first;
		while point_idx is not null loop
			polyline_data := polyline_data || point_idx || ',' || polypoints(point_idx) || ' ';
			point_idx := polypoints.next(point_idx);
		end loop;

		polyline_data := polyline_data || '" style="fill: none; stroke: '|| line_color ||'; stroke-width: '|| line_width ||';"';

		polyline_data := polyline_data || '/>';

		return polyline_data;

	end polyline;

	procedure page_polyline (
		page_in			in out		report_page.page,
		area_name		in		varchar2 default null,
		polypoints		in		polyline_points,
		line_color		in		varchar2 default report_defaults.def_color_line,
		line_width		in		varchar2 default report_defaults.def_size_line_width
	)

	as

		area_idx		varchar2(200) := 'M0';
		polyline_object		clob;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		polyline_object := polyline (
			polypoints		=> polypoints
			, line_color		=> line_color
			, line_width		=> line_width
		);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || polyline_object;

	end page_polyline;

	procedure report_polyline (
		report_object		in out		report_create.report,
		area_name		in		varchar2 default null,
		polypoints		in		polyline_points,
		line_color		in		varchar2 default report_defaults.def_color_line,
		line_width		in		varchar2 default report_defaults.def_size_line_width
	)

	as

	begin

		page_polyline (
			page_in			=> report_object.report_pages(report_object.report_current_page)
			, area_name		=> area_name
			, polypoints		=> polypoints
			, line_color		=> line_color
			, line_width		=> line_width
		);

	end report_polyline;

	procedure page_text (
		page_in			in out		report_page.page,
		text_in			in		varchar2,
		area_name		in		varchar2 default null,
		new_line		in		boolean default true,
		text_filter		in		varchar2 default null,
		text_rotate		in		varchar2 default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		text_obj		clob;
		track_x			number;
		track_y			number;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		text_obj := text_object(
				text_in			=> text_in
				, x_in			=> page_in.areas(area_idx).track.current_x
				, y_in			=> page_in.areas(area_idx).track.current_y
				, unit_type		=> page_in.attributes.unit_type
				, font_family		=> page_in.areas(area_idx).area_font
				, font_size		=> page_in.areas(area_idx).area_font_size
				, font_weight		=> page_in.areas(area_idx).area_font_weight
				, font_color		=> page_in.areas(area_idx).area_font_color
				, text_align		=> page_in.areas(area_idx).area_alignment
				, font_orientation	=> page_in.areas(area_idx).area_font_orientation
				, text_filter		=> text_filter
				, text_rotate		=> text_rotate
			);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || text_obj;

		report_helper.calculate_font_track_movement(text_in, page_in.areas(area_idx).area_font, page_in.areas(area_idx).area_font_size, track_x, track_y, new_line);
		report_page.add_area_track(page_in, area_idx, track_x, track_y);

	end page_text;

	procedure wrapped_page_text (
		page_in			in out		report_page.page,
		text_in			in		varchar2,
		area_name		in		varchar2 default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		text_span_size		number;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;
		text_span_size := page_in.areas(area_idx).end_x - page_in.areas(area_idx).track.current_x;

	end wrapped_page_text;

	procedure report_text (
		report_object		in out		report_create.report,
		text_in			in		varchar2,
		area_idx		in		varchar2 default null,
		new_line		in		boolean default true,
		text_filter		in		varchar2 default null,
		text_rotate		in		varchar2 default null
	)

	as

	begin

		page_text(
			page_in		=>	report_object.report_pages(report_object.report_current_page)
			, text_in	=>	text_in
			, area_name	=>	area_idx
			, new_line	=>	new_line
			, text_filter	=>	text_filter
			, text_rotate		=> text_rotate
		);

	end report_text;

	function text_object (
		text_in			in		varchar2,
		x_in			in		number,
		y_in			in		number,
		unit_type		in		varchar2,
		font_family		in		varchar2,
		font_size		in		number,
		font_weight		in		varchar2,
		font_color		in		varchar2,
		text_align		in		varchar2,
		text_filter		in		varchar2 default null,
		font_orientation	in		varchar2 default null,
		text_rotate		in		varchar2 default null
	)
	return clob

	as

		text_data		clob;

	begin

		text_data := '<text x="'|| x_in ||''|| unit_type ||'" y="'|| y_in ||''|| unit_type ||'" font-weight="'|| font_weight ||'" font-family="'|| font_family ||'" font-size="'|| font_size ||'" text-anchor="'|| text_align ||'" ';

		if text_filter is not null then
			text_data := text_data ||' filter="url(#'|| text_filter ||')"';
		end if;

		if text_rotate is not null then
			text_data := text_data || ' transform="rotate('|| text_rotate ||')"';
		end if;

		text_data := text_data || ' style="fill:'|| font_color ||';';

		if font_orientation = 'vertical' then
			text_data := text_data || 'writing-mode: tb; glyph-orientation-vertical: 0;';
		end if;

		text_data := text_data || '">';

		text_data := text_data || text_in ||'</text>';

		return text_data;

	end text_object;

	procedure report_textbox (
		report_object		in out		report_create.report,
		text_in			in		varchar2,
		area_idx		in		varchar2 default null,
		text_color		in		varchar2 default null
	)

	as

	begin

		page_textbox (
			page_in		=> report_object.report_pages(report_object.report_current_page)
			, text_in	=> text_in
			, area_name	=> area_idx
			, text_color	=> text_color
		);

	end report_textbox;

	procedure page_textbox (
		page_in			in out		report_page.page,
		text_in			in		varchar2,
		area_name		in		varchar2 default null,
		text_color		in		varchar2 default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		text_obj		clob;
		track_x			number;
		track_y			number;

		alignment		boolean := false;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		if page_in.areas(area_idx).area_alignment = 'end' then
			alignment := true;
		end if;

		text_obj := text_box (
				box_text_in		=> text_in
				, x_in			=> page_in.areas(area_idx).track.current_x
				, y_in			=> page_in.areas(area_idx).track.current_y
				, unit_type		=> page_in.attributes.unit_type
				, font_family		=> page_in.areas(area_idx).area_font
				, font_size		=> page_in.areas(area_idx).area_font_size
				, font_weight		=> page_in.areas(area_idx).area_font_weight
				, font_color		=> nvl(text_color, page_in.areas(area_idx).area_font_color)
				, box_border_width	=> report_defaults.def_size_border_width
				, box_border_color	=> report_defaults.def_color_border
				, box_fill_color	=> report_defaults.def_color_fill
				, box_padding		=> report_defaults.def_size_box_padding
				, box_corner_rounding	=> report_defaults.def_size_corner_rounding
				, justify_right		=> alignment
			);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || text_obj;

	end page_textbox;

	function text_box (
		box_text_in		in		varchar2,
		x_in			in		number,
		y_in			in		number,
		unit_type		in		varchar2,
		font_family		in		varchar2,
		font_size		in		number,
		font_weight		in		varchar2,
		font_color		in		varchar2,
		box_border_width	in		number default report_defaults.def_size_border_width,
		box_border_color	in		varchar2 default report_defaults.def_color_border,
		box_fill_color		in		varchar2 default report_defaults.def_color_fill,
		box_padding		in		number default report_defaults.def_size_box_padding,
		box_corner_rounding	in		number default report_defaults.def_size_corner_rounding,
		box_match_width_to_text	in		boolean default true,
		box_width_in		in		number default null,
		justify_right		in		boolean default false,
		box_filter		in		varchar2 default null,
		box_text_filter		in		varchar2 default null
	)
	return clob

	as

		-- Box text parms
		box_text_length		number := report_helper.mm_text_length(box_text_in, font_family, font_size);
		text_x			number;
		text_y			number;
		text_data		clob;

		-- Box parms
		box_x			number;
		box_y			number;
		box_height		number;
		box_width		number;
		box_round_x		number := box_corner_rounding;
		box_round_y		number := box_corner_rounding;
		box_padding_x		number;
		box_padding_y		number;
		box_data		clob;

		text_box_return		clob := '';

	begin

		-- Set box parms
		box_padding_x := round(((box_text_length/100) * box_padding) * 2,2);
		box_padding_y := round((report_helper.font_size_to_mm(font_size)/100) * box_padding,2) + 1;

		box_width := box_text_length + (2 * box_padding_x);
		if justify_right then
			box_x := x_in - box_width;
		else
			box_x := x_in;
		end if;
		box_y := y_in;
		box_height := font_size + (2 * box_padding_y);
		-- Draw the box
		box_data := '<rect
					x="'|| box_x ||''|| unit_type ||'"
					y="'|| box_y ||''|| unit_type ||'"
					rx="'|| box_round_x ||'"
					ry="'|| box_round_y ||'"
					width="'|| box_width ||''|| unit_type ||'"
					height="'|| box_height ||'"
					style="fill:'|| box_fill_color ||';stroke:'|| box_border_color ||';stroke-width:'|| box_border_width ||';"
			';
		if box_filter is not null then
			box_data := box_data || ' filter="url(#'|| box_filter ||')"';
		end if;
		box_data := box_data || '/>';

		-- Set the text parms
		if justify_right then
			text_x := x_in;
		else
			text_x := (x_in + box_width) - box_padding_x;
		end if;
		text_y := (box_y) + ( report_helper.font_size_to_mm(font_size));

		-- Draw the text
		text_data := text_object (
			text_in		=> box_text_in
			, x_in		=> text_x
			, y_in		=> text_y
			, unit_type	=> unit_type
			, font_family	=> font_family
			, font_size	=> font_size
			, font_weight	=> font_weight
			, font_color	=> font_color
			, text_align	=> 'end'
			, text_filter	=> box_text_filter
		);

		-- Create the textbox
		text_box_return := box_data || text_data;
		return text_box_return;

	end text_box;

	function line (
		x1_in			in		number,
		x2_in			in		number,
		y1_in			in		number,
		y2_in			in		number,
		unit_type		in		varchar2,
		line_color		in		varchar2,
		line_width		in		varchar2
	)
	return clob

	as

		line_data		clob;

	begin

		line_data := '<line x1="'|| x1_in ||'mm" y1="'|| y1_in ||'mm" x2="'|| x2_in ||'mm" y2="'|| y2_in ||'mm" style="stroke:'|| line_color ||';stroke-width:'|| line_width ||'"/>';

		return line_data;

	end line;

	procedure page_line (
		page_in			in out		report_page.page,
		line_type		in		varchar2,
		line_type_val		in		number default null,
		area_name		in		varchar2 default null
	)

	as

		line_obj		clob;
		area_idx		varchar2(200) := 'M0';

		start_pos_x		number;
		start_pos_y		number;
		end_pos_x		number;
		end_pos_y		number;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		if line_type = 'vertical' then
			start_pos_x := page_in.areas(area_idx).track.current_x;
			start_pos_y := page_in.areas(area_idx).track.current_y;
			end_pos_x := start_pos_x;
			end_pos_y := page_in.areas(area_idx).end_y;
		elsif line_type = 'vertical_pct' then
			start_pos_x := page_in.areas(area_idx).track.current_x;
			start_pos_y := page_in.areas(area_idx).track.current_y;
			end_pos_x := start_pos_x;
			end_pos_y := start_pos_y + (((page_in.areas(area_idx).end_y - page_in.areas(area_idx).start_y)/100) * line_type_val);
		elsif line_type = 'horizontal' then
			start_pos_x := page_in.areas(area_idx).track.current_x;
			start_pos_y := page_in.areas(area_idx).track.current_y;
			end_pos_x := page_in.areas(area_idx).end_x;
			end_pos_y := page_in.areas(area_idx).track.current_y;
		else
			start_pos_x := page_in.areas(area_idx).track.current_x;
			start_pos_y := page_in.areas(area_idx).track.current_y;
			end_pos_x := page_in.areas(area_idx).end_x;
			end_pos_y := start_pos_y;
		end if;

		line_obj := line(
				x1_in		=>	start_pos_x
				, x2_in		=>	end_pos_x
				, y1_in		=>	start_pos_y
				, y2_in		=>	end_pos_y
				, unit_type	=>	page_in.attributes.unit_type
				, line_color	=>	report_defaults.def_color_line
				, line_width	=>	report_defaults.def_size_line_width
			);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || line_obj;

	end page_line;

	procedure report_line (
		report_object		in out		report_create.report,
		line_type		in		varchar2,
		line_type_val		in		number default null,
		area_idx		in		varchar2 default null
	)

	as

	begin

		page_line(
			page_in		=> report_object.report_pages(report_object.report_current_page)
			, line_type	=> line_type
			, line_type_val	=> line_type_val
			, area_name	=> area_idx
		);

	end report_line;

	function rect (
		x_in			in		number,
		y_in			in		number,
		unit_type		in		varchar2,
		height_in		in		number,
		width_in		in		number,
		rect_fill		in		varchar2,
		rect_filter		in		varchar2 default null,
		rect_title		in		varchar2 default null
	)
	return clob

	as

		rect_data		clob;

	begin

		rect_data := '<rect
					x="'|| x_in ||''|| unit_type ||'"
					y="'|| y_in ||''|| unit_type ||'"
					width="'|| width_in ||''|| unit_type ||'"
					height="'|| height_in ||''|| unit_type ||'"
					style="fill:'|| rect_fill ||';"
			      ';
		if rect_filter is not null then
			rect_data := rect_data ||' filter="url(#'|| rect_filter ||')"';
		end if;

		if rect_title is not null then
			rect_data := rect_data || '><title>'|| rect_title ||'</title></rect>';
		else
			rect_data := rect_data || '/>';
		end if;

		return rect_data;

	end rect;

	procedure page_rect (
		page_in			in out		report_page.page,
		area_name		in		varchar2 default null,
		rect_type		in		varchar2,
		rect_length		in		number,
		rect_height		in		number,
		rect_fill		in		varchar2 default report_defaults.def_color_fill,
		rect_filter		in		varchar2 default null,
		rect_title		in		varchar2 default null
	)

	as

		rect_obj		clob;
		rect_x			number := page_in.areas(area_name).track.current_x;
		rect_y			number := page_in.areas(area_name).track.current_y;
		rect_length_calc	number := rect_length;
		area_idx		varchar2(200) := 'M0';

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		if rect_type = 'horizontal_pct' then
			rect_length_calc := ((page_in.areas(area_name).end_x - page_in.areas(area_name).start_x)/100) * rect_length;
		elsif rect_type = 'horizontal_bar_chart' then
			rect_y := rect_y - rect_height;
		end if;

		rect_obj := rect(
				x_in		=> rect_x
				, y_in		=> rect_y
				, unit_type	=> page_in.attributes.unit_type
				, height_in	=> rect_height
				, width_in	=> rect_length_calc
				, rect_fill	=> rect_fill
				, rect_filter	=> rect_filter
				, rect_title	=> rect_title
			);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || rect_obj;

	end page_rect;

	procedure report_rect (
		report_object		in out		report_create.report,
		area_name		in		varchar2 default null,
		rect_type		in		varchar2,
		rect_length		in		number,
		rect_height		in		number,
		rect_fill		in		varchar2 default report_defaults.def_color_fill,
		rect_filter		in		varchar2 default null,
		rect_title		in		varchar2 default null
	)

	as

	begin

		page_rect(
			page_in		=> report_object.report_pages(report_object.report_current_page)
			, area_name	=> area_name
			, rect_type	=> rect_type
			, rect_length	=> rect_length
			, rect_height	=> rect_height
			, rect_fill	=> rect_fill
			, rect_filter	=> rect_filter
			, rect_title	=> rect_title
		);

	end report_rect;

	function circle (
		x_in			in		number,
		y_in			in		number,
		unit_type		in		varchar2,
		circle_radius		in		number,
		circle_stroke		in		number,
		circle_stroke_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill		in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	)
	return clob

	as

		circle_data		clob;

	begin

		circle_data := '<circle cx="'|| x_in ||''|| unit_type ||'" cy="'|| y_in ||''|| unit_type ||'" r="'|| circle_radius ||''|| unit_type ||'" stroke="'|| circle_stroke_color ||'" stroke-width="'|| circle_stroke ||'" fill="'|| circle_fill ||'"';

		if circle_filter is not null then
			null;
		end if;

		if circle_filter is not null then
			circle_data := circle_data ||' filter="url(#'|| circle_filter ||')"';
		end if;

		circle_data := circle_data || '/>';

		return circle_data;

	end circle;

	procedure page_circle (
		page_in			in out		report_page.page,
		area_name		in		varchar2 default null,
		circle_size		in		number,
		circle_line_size	in		number,
		circle_line_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill		in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		circle_obj		clob;
		circle_x		number := page_in.areas(area_name).track.current_x;
		circle_y		number := page_in.areas(area_name).track.current_y;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		circle_obj := circle (
				x_in			=> circle_x
				, y_in			=> circle_y
				, unit_type		=> page_in.attributes.unit_type
				, circle_radius		=> circle_size
				, circle_stroke		=> circle_line_size
				, circle_stroke_color	=> circle_line_color
				, circle_fill		=> circle_fill
				, circle_filter		=> circle_filter
		);

		page_in.areas(area_idx).area_data := page_in.areas(area_idx).area_data || circle_obj;

	end page_circle;

	procedure report_circle (
		report_object		in out		report_create.report,
		area_name		in		varchar2 default null,
		circle_size		in		number,
		circle_line_size	in		number,
		circle_line_color	in		varchar2 default report_defaults.def_color_line,
		circle_fill		in		varchar2 default report_defaults.def_color_fill,
		circle_filter		in		varchar2 default null
	)

	as

	begin

		page_circle(
			page_in			=> report_object.report_pages(report_object.report_current_page)
			, area_name		=> area_name
			, circle_size		=> circle_size
			, circle_line_size	=> circle_line_size
			, circle_line_color	=> circle_line_color
			, circle_fill		=> circle_fill
			, circle_filter		=> circle_filter
		);

	end report_circle;

end report_components;
/
