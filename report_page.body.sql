create or replace package body report_page

as

	procedure set_attribute (
		page_in			in out		page,
		attribute_name		in		varchar2,
		attribute_value		in		varchar2
	)

	as

	begin

		if attribute_name = 'header' then
			page_in.attributes.has_header := attribute_value;
		elsif attribute_name = 'footer' then
			page_in.attributes.has_footer := attribute_value;
		elsif attribute_name = 'tracking' then
			page_in.attributes.is_tracked := attribute_value;
		elsif attribute_name = 'pagename' then
			page_in.attributes.page_name := attribute_value;
		end if;

	end set_attribute;

	function make_page (
		width_in		in		number,
		height_in		in		number,
		unit_in			in		varchar2 default 'mm',
		orientation_in		in		varchar2 default 'portrait',
		template_in		in		varchar2 default null
	)
	return page

	as

		ret_page		page;
		page_1pct_width		number := round(width_in/100,2);
		page_1pct_height	number := round(height_in/100,2);

	begin

		ret_page.dimensions.page_width := width_in;
		ret_page.dimensions.page_height := height_in;
		ret_page.attributes.unit_type := unit_in;
		ret_page.attributes.orientation := orientation_in;
		ret_page.attributes.pagenumber := -9999;
		ret_page.attributes.has_header := pd_header;
		ret_page.attributes.has_footer := pd_footer;
		ret_page.attributes.is_tracked := pd_tracking;
		ret_page.attributes.track.current_x := 0;
		ret_page.attributes.track.current_y := 0;
		ret_page.areas('M0').start_x := 0;
		ret_page.areas('M0').start_y := 0;
		ret_page.areas('M0').end_x := ret_page.dimensions.page_width;
		ret_page.areas('M0').end_y := ret_page.dimensions.page_height;
		ret_page.areas('M0').area# := 0;
		ret_page.areas('M0').area_name := 'Main area';
		ret_page.areas('M0').area_font := pd_font;
		ret_page.areas('M0').area_font_weight := pd_font_weight;
		ret_page.areas('M0').area_font_size := pd_font_size;
		ret_page.areas('M0').area_font_color := pd_font_color;
		ret_page.areas('M0').area_alignment := 'start';
		ret_page.areas('M0').area_data := '';
		ret_page.areas('M0').is_tracked := pd_tracking;
		ret_page.areas('M0').track.current_x := 0;
		ret_page.areas('M0').track.current_y := 0;

		-- Define header and footers from the beginning
		-- They will only show up if the correct attributes are set.
		-- Defaults will tell us how much to reserve for header and footer
		ret_page.page_footer.fixed_type := 'footer';
		ret_page.page_footer.fixed_x1 := page_1pct_width * report_defaults.def_page_left_margin;
		ret_page.page_footer.fixed_x2 := ret_page.dimensions.page_width - (report_defaults.def_page_right_margin * page_1pct_width);
		ret_page.page_footer.fixed_y1 := ret_page.dimensions.page_height - (report_defaults.def_size_footer_height * page_1pct_height);
		ret_page.page_footer.fixed_y2 := ret_page.dimensions.page_height;
		ret_page.page_footer.fixed_data := report_components.line(
								x1_in			=> ret_page.page_footer.fixed_x1
								, x2_in			=> ret_page.page_footer.fixed_x2
								, y1_in			=> ret_page.page_footer.fixed_y1
								, y2_in			=> ret_page.page_footer.fixed_y1
								, unit_type		=> ret_page.attributes.unit_type
								, line_color		=> '#C3C3C3'
								, line_width		=> '0.5'
							);
		ret_page.page_footer.fixed_data := ret_page.page_footer.fixed_data || report_components.text_object(
								text_in			=> '#owner#'
								, x_in			=> ret_page.page_footer.fixed_x1
								, y_in			=> ret_page.page_footer.fixed_y1 + 3
								, unit_type		=> ret_page.attributes.unit_type
								, font_family		=> 'Arial'
								, font_size		=> 10
								, font_weight		=> 'normal'
								, font_color		=> '#C3C3C3'
								, text_align		=> 'start'
							);
		ret_page.page_footer.fixed_data := ret_page.page_footer.fixed_data || report_components.text_object(
								text_in			=> '#PAGENUMBER# of #TOTAL_PAGECOUNT#'
								, x_in			=> ret_page.page_footer.fixed_x2
								, y_in			=> ret_page.page_footer.fixed_y1 + 3
								, unit_type		=> ret_page.attributes.unit_type
								, font_family		=> 'Arial'
								, font_size		=> 10
								, font_weight		=> 'normal'
								, font_color		=> '#C3C3C3'
								, text_align		=> 'end'
							);
		ret_page.page_header.fixed_type := 'header';
		ret_page.page_header.fixed_x1 := page_1pct_width * report_defaults.def_page_left_margin;
		ret_page.page_header.fixed_x2 := ret_page.dimensions.page_width - (report_defaults.def_page_right_margin * page_1pct_width);
		ret_page.page_header.fixed_y1 := 0;
		ret_page.page_header.fixed_y2 := ret_page.dimensions.page_height + (report_defaults.def_size_header_height * page_1pct_height);

		ret_page.page_start := '<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="'|| width_in ||''|| unit_in ||'" height="'|| height_in ||''|| unit_in ||'">';
		ret_page.page_end := '</svg>';

		page_size_update(ret_page);

		return ret_page;

	end make_page;

	function iso_page (
		iso_name_in		in		varchar2 default 'A4',
		orientation_in		in		varchar2 default 'portrait',
		template_in		in		varchar2 default null
	)
	return page

	as

		iso_page_ret		page;

		name_upper		varchar2(4000) := upper(iso_name_in);

		width_set		number;
		height_set		number;
		unit_set		varchar2(200);
		temp_num		number;

	begin

		if name_upper = 'A4' then
			width_set := 210;
			height_set := 297;
			unit_set := 'mm';
		elsif name_upper = 'A3' then
			width_set := 297;
			height_set := 420;
			unit_set := 'mm';
		elsif name_upper = 'LETTER' then
			width_set := 215.9;
			height_set := 279.4;
			unit_set := 'mm';
		elsif name_upper = 'LEGAL' then
			width_set := 215.9;
			height_set := 355.6;
			unit_set := 'mm';
		else
			-- Default to A4
			width_set := 210;
			height_set := 297;
			unit_set := 'mm';
		end if;

		if orientation_in = 'landscape' then
			temp_num := height_set;
			height_set := width_set;
			width_set := temp_num;
		end if;

		iso_page_ret := make_page(width_set, height_set, unit_set, orientation_in);

		if template_in is not null then
			report_templates.apply_template(iso_page_ret, template_in);
			page_size_update(iso_page_ret);
		end if;

		return iso_page_ret;

	end iso_page;

	procedure add_page_track (
		page_in			in out		page,
		add_to_x		in		number,
		add_to_y		in		number
	)

	as

	begin

		if page_in.attributes.is_tracked = 1 then
			page_in.attributes.track.current_x := page_in.attributes.track.current_x + add_to_x;
			page_in.attributes.track.current_y := page_in.attributes.track.current_y + add_to_y;
		end if;

	end add_page_track;

	procedure add_area_track (
		page_in			in out		page,
		area_in			in		varchar2,
		add_to_x		in		number,
		add_to_y		in		number
	)

	as

	begin

		if page_in.areas(area_in).is_tracked = 1 then
			if page_in.areas(area_in).area_alignment = 'end' then
				page_in.areas(area_in).track.current_x := page_in.areas(area_in).track.current_x - add_to_x;
			else
				page_in.areas(area_in).track.current_x := page_in.areas(area_in).track.current_x + add_to_x;
			end if;
			page_in.areas(area_in).track.current_y := page_in.areas(area_in).track.current_y + add_to_y;
		end if;

	end add_area_track;

	procedure page_size_update (
		page_in			in out		page
	)

	as

		total_page_size		number := 0;
		area_idx		varchar2(4000);

	begin

		total_page_size := total_page_size + length(page_in.page_start);
		total_page_size := total_page_size + length(page_in.page_end);
		-- Calc size of all areas
		area_idx := page_in.areas.first;
		while area_idx is not null loop
			if page_in.areas(area_idx).area_data is not null then
				total_page_size := total_page_size + length(page_in.areas(area_idx).area_data);
			end if;
			area_idx := page_in.areas.next(area_idx);
		end loop;

		page_in.page_size := total_page_size;

	end page_size_update;

	procedure page_to_file (
		page_in			in		page,
		file_name_in		in		varchar2 default null
	)

	as

		def_idx			varchar2(4000);
		area_idx		varchar2(4000);
		complete_page		clob := '';
		page_sort_out		varchar2(10);
		file_name		varchar2(500);

	begin

		complete_page := complete_page || page_in.page_start;

		complete_page := complete_page || '<defs>';
		def_idx := page_in.defs.first;
		while def_idx is not null loop
			complete_page := complete_page || page_in.defs(def_idx).def_data;
			def_idx := page_in.defs.next(def_idx);
		end loop;
		complete_page := complete_page || '</defs>';

		area_idx := page_in.areas.first;
		while area_idx is not null loop
			complete_page := complete_page || page_in.areas(area_idx).area_data;
			area_idx := page_in.areas.next(area_idx);
		end loop;

		-- Fixed parts
		if page_in.attributes.has_header = 1 then
			complete_page := complete_page || page_in.page_header.fixed_data;
		end if;

		if page_in.attributes.has_footer = 1 then
			complete_page := complete_page || page_in.page_footer.fixed_data;
		end if;

		complete_page := complete_page || page_in.page_end;

		if page_in.attributes.pagenumber is not null then
			page_sort_out := page_in.attributes.pagenumber;
		else
			page_sort_out := page_in.page_id;
		end if;

		if length(page_sort_out) <= 2 then
			page_sort_out := lpad(page_sort_out,3,'0');
		end if;

		if file_name_in is null then
			file_name := 'sp_' || page_sort_out || '.svg';
		else
			file_name := file_name_in;
		end if;

		misc.clob_to_file(file_name, 'REPORT_OUT', complete_page);

	end page_to_file;

	procedure page_data_replace (
		page_in			in out		page,
		replace_what		in		varchar2,
		replace_with		in		varchar2
	)

	as

		area_idx		varchar2(200);

	begin

		area_idx := page_in.areas.first;
		while area_idx is not null loop
			page_in.areas(area_idx).area_data := replace(page_in.areas(area_idx).area_data, replace_what, replace_with);
			area_idx := page_in.areas.next(area_idx);
		end loop;

		-- Fixed parts
		if page_in.attributes.has_header = 1 then
			page_in.page_header.fixed_data := replace(page_in.page_header.fixed_data, replace_what, replace_with);
		end if;

		if page_in.attributes.has_footer = 1 then
			page_in.page_footer.fixed_data := replace(page_in.page_footer.fixed_data, replace_what, replace_with);
		end if;

	end page_data_replace;

end report_page;
/
