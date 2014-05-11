create or replace package body report_data_components

as

	procedure report_line_graph (
		report_object		in out		report_create.report,
		area_name		in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_data		in		line_graph_list,
		graph_height		in		number default null,
		graph_width		in		number default null
	)

	as

	begin

		page_line_graph(
			page_in			=>	report_object.report_pages(report_object.report_current_page)
			, area_name		=>	area_name
			, area_fill_type	=>	area_fill_type
			, graph_data		=>	graph_data
			, graph_height		=>	graph_height
			, graph_width		=>	graph_width
		);

	end report_line_graph;

	procedure page_line_graph (
		page_in			in out		report_page.page,
		area_name		in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_data		in		line_graph_list,
		graph_height		in		number default null,
		graph_width		in		number default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		data_idx		varchar2(4000);
		height			number;
		width			number;
		bar_highest_val		number := 0;
		bar_scaling		number;
		bar_points		number := graph_data.count;
		point_width		number;
		bar_padding		number := 0.1;
		record_y		number;
		record_x		number;

		pixel_constant		number := 3.779528;

		line_points		report_components.polyline_points;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		if area_fill_type = 'full' then
			if page_in.areas(area_idx).is_tracked = 1 then
				width := page_in.areas(area_idx).end_x - page_in.areas(area_idx).track.current_x;
				height := page_in.areas(area_idx).end_y - page_in.areas(area_idx).track.current_y;
			else
				width := page_in.areas(area_idx).end_x - page_in.areas(area_idx).start_x;
				height := page_in.areas(area_idx).end_y - page_in.areas(area_idx).start_y;
			end if;
		elsif (graph_height is not null and graph_width is not null) then
			height := graph_height;
			width := graph_width;
		end if;

		-- Find the highest value in graph data
		data_idx := graph_data.first;
		while data_idx is not null loop
			if graph_data(data_idx) > bar_highest_val then
				bar_highest_val := graph_data(data_idx);
			end if;
			data_idx := graph_data.next(data_idx);
		end loop;

		point_width := round(width/bar_points,2);
		bar_scaling := round(height/bar_highest_val,2);

		-- y axis line
		report_components.page_line(
			page_in		=> page_in,
			line_type	=> 'vertical',
			area_name	=> area_idx
		);

		report_area.area_move_y(page_in, area_idx, 0, 'end');

		-- x axis line
		report_components.page_line(
			page_in		=> page_in,
			line_type	=> 'horizontal',
			area_name	=> area_idx
		);

		-- First moves and records
		-- report_area.area_move_x(page_in, area_idx, point_width/2);

		-- Convert to polyline datatype
		data_idx := graph_data.first;
		while data_idx is not null loop
			record_y := (page_in.areas(area_idx).track.current_y - (graph_data(data_idx) * bar_scaling)) * pixel_constant;
			record_x := page_in.areas(area_idx).track.current_x * pixel_constant;
			line_points(record_x) := record_y;
			report_area.area_move_x(page_in, area_idx, point_width);
			data_idx := graph_data.next(data_idx);
		end loop;

		report_components.page_polyline(page_in, area_idx, line_points);

	end page_line_graph;

	procedure report_bar_graph (
		report_object		in out		report_create.report,
		area_name		in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_orientation	in		varchar2 default 'vertical',
		graph_data		in		bar_graph_list,
		graph_height		in		number default null,
		graph_width		in		number default null
	)

	as

	begin

		page_bar_graph (
			page_in			=>	report_object.report_pages(report_object.report_current_page)
			, area_name		=>	area_name
			, area_fill_type	=>	area_fill_type
			, graph_orientation	=>	graph_orientation
			, graph_data		=>	graph_data
			, graph_height		=>	graph_height
			, graph_width		=>	graph_width
		);

	end report_bar_graph;

	procedure page_bar_graph (
		page_in			in out		report_page.page,
		area_name		in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_orientation	in		varchar2 default 'vertical',
		graph_data		in		bar_graph_list,
		graph_height		in		number default null,
		graph_width		in		number default null
	)

	as

		area_idx		varchar2(200) := 'M0';
		data_idx		varchar2(4000);
		height			number;
		width			number;
		bar_highest_val		number := 0;
		bar_scaling		number;
		bar_points		number := graph_data.count;
		point_width		number;
		bar_padding		number := 0.1;
		record_y		number;
		record_x		number;

		bar_color_r		number := 0;
		bar_color_g		number := 0;
		bar_color_b		number := 254;
		r_increment		number := 0;
		g_increment		number := 8;
		b_increment		number := -8;

	begin

		if area_name is not null then
			area_idx := area_name;
		end if;

		if area_fill_type = 'full' then
			if page_in.areas(area_idx).is_tracked = 1 then
				width := page_in.areas(area_idx).end_x - page_in.areas(area_idx).track.current_x;
				height := page_in.areas(area_idx).end_y - page_in.areas(area_idx).track.current_y;
			else
				width := page_in.areas(area_idx).end_x - page_in.areas(area_idx).start_x;
				height := page_in.areas(area_idx).end_y - page_in.areas(area_idx).start_y;
			end if;
		elsif (graph_height is not null and graph_width is not null) then
			height := graph_height;
			width := graph_width;
		end if;

		-- Find the highest value in graph data
		data_idx := graph_data.first;
		while data_idx is not null loop
			if graph_data(data_idx) > bar_highest_val then
				bar_highest_val := graph_data(data_idx);
			end if;
			data_idx := graph_data.next(data_idx);
		end loop;

		if graph_orientation = 'vertical' then
			point_width := round(width/bar_points,2);
			bar_scaling := round(height/bar_highest_val,2);
		elsif graph_orientation = 'horizontal' then
			point_width := round(height/bar_points,2);
			bar_scaling := round(width/bar_highest_val,2);
		end if;

		-- y axis line
		report_components.page_line(
			page_in		=> page_in,
			line_type	=> 'vertical',
			area_name	=> area_idx
		);

		record_y := page_in.areas(area_idx).track.current_y;
		report_area.area_move_y(page_in, area_idx, 0, 'end');

		-- x axis line
		report_components.page_line(
			page_in		=> page_in,
			line_type	=> 'horizontal',
			area_name	=> area_idx
		);

		if graph_orientation = 'horizontal' then
			-- Move y back
			report_area.area_move_y(page_in, area_idx, record_y,'unit_type_to');
			report_area.area_move_y(page_in, area_idx, point_width - ( point_width * (bar_padding * 2)));
			report_area.area_move_x(page_in, area_idx, 0.2, 'pct');
		elsif graph_orientation = 'vertical' then
			report_area.area_move_y(page_in, area_idx, -0.2, 'pct');
		end if;

		-- Draw bars
		data_idx := graph_data.first;
		while data_idx is not null loop
			if graph_orientation = 'vertical' then
				report_area.area_move_x(page_in, area_idx, (point_width * bar_padding));
				report_components.page_rect(page_in, area_idx, 'horizontal_bar_chart', (point_width * (1 - (2 * bar_padding))), (graph_data(data_idx) * bar_scaling), 'rgb('|| bar_color_r ||','|| bar_color_g ||','|| bar_color_b ||')', null, data_idx);
				report_area.area_move_x(page_in, area_idx, (point_width * (1 - bar_padding)));
				record_y := page_in.areas(area_idx).track.current_y;
				record_x := page_in.areas(area_idx).track.current_x;
				report_area.area_move_x(page_in, area_idx, -(point_width/2));
				report_area.area_move_y(page_in, area_idx, 6);
				report_components.page_text(page_in, data_idx, area_idx, false, null);
				report_area.area_move_y(page_in, area_idx, record_y,'unit_type_to');
				report_area.area_move_x(page_in, area_idx, record_x,'unit_type_to');
			elsif graph_orientation = 'horizontal' then
				report_area.area_move_y(page_in, area_idx, (point_width * bar_padding));
				report_components.page_rect(page_in, area_idx, 'horizontal_bar_chart', (graph_data(data_idx) * bar_scaling), (point_width * (1 - (2 * bar_padding))), 'rgb('|| bar_color_r ||','|| bar_color_g ||','|| bar_color_b ||')', null, data_idx);
				report_area.area_move_y(page_in, area_idx, (point_width * (1 - bar_padding)));
				record_y := page_in.areas(area_idx).track.current_y;
				record_x := page_in.areas(area_idx).track.current_x;
				report_area.area_move_x(page_in, area_idx, -2);
				report_area.area_move_y(page_in, area_idx, -(point_width));
				report_area.area_set_alignment(page_in, area_idx, 'end');
				report_components.page_text(page_in, data_idx, area_idx, false, null);
				report_area.area_move_y(page_in, area_idx, record_y,'unit_type_to');
				report_area.area_move_x(page_in, area_idx, record_x,'unit_type_to');
			end if;
			-- increment colors
			bar_color_r := bar_color_r + r_increment;
			bar_color_g := bar_color_g + g_increment;
			bar_color_b := bar_color_b + b_increment;
			data_idx := graph_data.next(data_idx);
		end loop;

	end page_bar_graph;

end report_data_components;
/
