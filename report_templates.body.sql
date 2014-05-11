create or replace package body report_templates

as

	type template_collections is table of report_page.page_areas index by varchar2(4000);
	landscapes			template_collections;
	portraits			template_collections;

	procedure init_templates (
		enable_tracking		in		number,
		page_width		in		number,
		page_height		in		number
	)

	as

		width_1_pct		number := (page_width/100);
		height_1_pct		number := (page_height/100);

	begin


		/* Landscape simple front page */
		landscapes('SIMPLE FRONT')('TITLE').start_x := width_1_pct * 50;
		landscapes('SIMPLE FRONT')('TITLE').start_y := height_1_pct * 40;
		landscapes('SIMPLE FRONT')('TITLE').end_x := width_1_pct * 99;
		landscapes('SIMPLE FRONT')('TITLE').end_y := height_1_pct * 45;
		landscapes('SIMPLE FRONT')('TITLE').area# := 1;
		landscapes('SIMPLE FRONT')('TITLE').area_name := 'Report title';
		landscapes('SIMPLE FRONT')('TITLE').area_font := 'Arial';
		landscapes('SIMPLE FRONT')('TITLE').area_font_weight := 'bold';
		landscapes('SIMPLE FRONT')('TITLE').area_font_color := '#000000';
		landscapes('SIMPLE FRONT')('TITLE').area_font_size := 30;
		landscapes('SIMPLE FRONT')('TITLE').area_alignment := 'start';
		landscapes('SIMPLE FRONT')('TITLE').area_data := '';
		landscapes('SIMPLE FRONT')('TITLE').is_tracked := enable_tracking;
		landscapes('SIMPLE FRONT')('TITLE').track.current_x := landscapes('SIMPLE FRONT')('TITLE').start_x;
		landscapes('SIMPLE FRONT')('TITLE').track.current_y := landscapes('SIMPLE FRONT')('TITLE').start_y;
		landscapes('SIMPLE FRONT')('SUBTITLE').start_x := width_1_pct * 50;
		landscapes('SIMPLE FRONT')('SUBTITLE').start_y := height_1_pct * 45;
		landscapes('SIMPLE FRONT')('SUBTITLE').end_x := width_1_pct * 99;
		landscapes('SIMPLE FRONT')('SUBTITLE').end_y := height_1_pct * 50;
		landscapes('SIMPLE FRONT')('SUBTITLE').area# := 2;
		landscapes('SIMPLE FRONT')('SUBTITLE').area_name := 'Report subtitle';
		landscapes('SIMPLE FRONT')('SUBTITLE').area_font := 'Arial';
		landscapes('SIMPLE FRONT')('SUBTITLE').area_font_weight := 'normal';
		landscapes('SIMPLE FRONT')('SUBTITLE').area_font_color := '#000000';
		landscapes('SIMPLE FRONT')('SUBTITLE').area_font_size := 20;
		landscapes('SIMPLE FRONT')('SUBTITLE').area_alignment := 'start';
		landscapes('SIMPLE FRONT')('SUBTITLE').area_data := '';
		landscapes('SIMPLE FRONT')('SUBTITLE').is_tracked := enable_tracking;
		landscapes('SIMPLE FRONT')('SUBTITLE').track.current_x := landscapes('SIMPLE FRONT')('SUBTITLE').start_x;
		landscapes('SIMPLE FRONT')('SUBTITLE').track.current_y := landscapes('SIMPLE FRONT')('SUBTITLE').start_y;

		/* Landscape section front page */
		landscapes('SECTION FRONT')('TITLE').start_x := width_1_pct * 50;
		landscapes('SECTION FRONT')('TITLE').start_y := height_1_pct * 40;
		landscapes('SECTION FRONT')('TITLE').end_x := width_1_pct * 99;
		landscapes('SECTION FRONT')('TITLE').end_y := height_1_pct * 45;
		landscapes('SECTION FRONT')('TITLE').area# := 1;
		landscapes('SECTION FRONT')('TITLE').area_name := 'Section title';
		landscapes('SECTION FRONT')('TITLE').area_font := 'Arial';
		landscapes('SECTION FRONT')('TITLE').area_font_weight := 'bold';
		landscapes('SECTION FRONT')('TITLE').area_font_color := '#000000';
		landscapes('SECTION FRONT')('TITLE').area_font_size := 30;
		landscapes('SECTION FRONT')('TITLE').area_alignment := 'middle';
		landscapes('SECTION FRONT')('TITLE').area_data := '';
		landscapes('SECTION FRONT')('TITLE').is_tracked := enable_tracking;
		landscapes('SECTION FRONT')('TITLE').track.current_x := landscapes('SIMPLE FRONT')('TITLE').start_x;
		landscapes('SECTION FRONT')('TITLE').track.current_y := landscapes('SIMPLE FRONT')('TITLE').start_y;
		landscapes('SECTION FRONT')('SUBTITLE').start_x := width_1_pct * 50;
		landscapes('SECTION FRONT')('SUBTITLE').start_y := height_1_pct * 45;
		landscapes('SECTION FRONT')('SUBTITLE').end_x := width_1_pct * 99;
		landscapes('SECTION FRONT')('SUBTITLE').end_y := height_1_pct * 50;
		landscapes('SECTION FRONT')('SUBTITLE').area# := 2;
		landscapes('SECTION FRONT')('SUBTITLE').area_name := 'Section subtitle';
		landscapes('SECTION FRONT')('SUBTITLE').area_font := 'Arial';
		landscapes('SECTION FRONT')('SUBTITLE').area_font_weight := 'normal';
		landscapes('SECTION FRONT')('SUBTITLE').area_font_color := '#000000';
		landscapes('SECTION FRONT')('SUBTITLE').area_font_size := 20;
		landscapes('SECTION FRONT')('SUBTITLE').area_alignment := 'middle';
		landscapes('SECTION FRONT')('SUBTITLE').area_data := '';
		landscapes('SECTION FRONT')('SUBTITLE').is_tracked := enable_tracking;
		landscapes('SECTION FRONT')('SUBTITLE').track.current_x := landscapes('SIMPLE FRONT')('SUBTITLE').start_x;
		landscapes('SECTION FRONT')('SUBTITLE').track.current_y := landscapes('SIMPLE FRONT')('SUBTITLE').start_y;

		/* Landscape 3 columns */
		landscapes('3 COLUMNS')('COLUMN1').start_x := width_1_pct * 2;
		landscapes('3 COLUMNS')('COLUMN1').start_y := height_1_pct * 2;
		landscapes('3 COLUMNS')('COLUMN1').end_x := width_1_pct * 33.3;
		landscapes('3 COLUMNS')('COLUMN1').end_y := height_1_pct * 98;
		landscapes('3 COLUMNS')('COLUMN1').area# := 1;
		landscapes('3 COLUMNS')('COLUMN1').area_name := 'Column 1 of 3 columns';
		landscapes('3 COLUMNS')('COLUMN1').area_font := 'Arial';
		landscapes('3 COLUMNS')('COLUMN1').area_font_weight := 'normal';
		landscapes('3 COLUMNS')('COLUMN1').area_font_color := '#000000';
		landscapes('3 COLUMNS')('COLUMN1').area_font_size := 12;
		landscapes('3 COLUMNS')('COLUMN1').area_alignment := 'start';
		landscapes('3 COLUMNS')('COLUMN1').is_tracked := enable_tracking;
		landscapes('3 COLUMNS')('COLUMN1').track.current_x := landscapes('3 COLUMNS')('COLUMN1').start_x;
		landscapes('3 COLUMNS')('COLUMN1').track.current_y := landscapes('3 COLUMNS')('COLUMN1').start_y;
		landscapes('3 COLUMNS')('COLUMN2').start_x := width_1_pct * 33.3;
		landscapes('3 COLUMNS')('COLUMN2').start_y := height_1_pct * 2;
		landscapes('3 COLUMNS')('COLUMN2').end_x := (width_1_pct * 33.3) + (width_1_pct * 31.3);
		landscapes('3 COLUMNS')('COLUMN2').end_y := height_1_pct * 98;
		landscapes('3 COLUMNS')('COLUMN2').area# := 2;
		landscapes('3 COLUMNS')('COLUMN2').area_name := 'Column 2 of 3 columns';
		landscapes('3 COLUMNS')('COLUMN2').area_font := 'Arial';
		landscapes('3 COLUMNS')('COLUMN2').area_font_weight := 'normal';
		landscapes('3 COLUMNS')('COLUMN2').area_font_color := '#000000';
		landscapes('3 COLUMNS')('COLUMN2').area_font_size := 12;
		landscapes('3 COLUMNS')('COLUMN2').area_alignment := 'start';
		landscapes('3 COLUMNS')('COLUMN2').is_tracked := enable_tracking;
		landscapes('3 COLUMNS')('COLUMN2').track.current_x := landscapes('3 COLUMNS')('COLUMN2').start_x;
		landscapes('3 COLUMNS')('COLUMN2').track.current_y := landscapes('3 COLUMNS')('COLUMN2').start_y;
		landscapes('3 COLUMNS')('COLUMN3').start_x := (width_1_pct * 33.3) + (width_1_pct * 31.3);
		landscapes('3 COLUMNS')('COLUMN3').start_y := height_1_pct * 2;
		landscapes('3 COLUMNS')('COLUMN3').end_x := width_1_pct * 98;
		landscapes('3 COLUMNS')('COLUMN3').end_y := height_1_pct * 98;
		landscapes('3 COLUMNS')('COLUMN3').area# := 3;
		landscapes('3 COLUMNS')('COLUMN3').area_name := 'Column 3 of 3 columns';
		landscapes('3 COLUMNS')('COLUMN3').area_font := 'Arial';
		landscapes('3 COLUMNS')('COLUMN3').area_font_weight := 'normal';
		landscapes('3 COLUMNS')('COLUMN3').area_font_color := '#000000';
		landscapes('3 COLUMNS')('COLUMN3').area_font_size := 12;
		landscapes('3 COLUMNS')('COLUMN3').area_alignment := 'start';
		landscapes('3 COLUMNS')('COLUMN3').is_tracked := enable_tracking;
		landscapes('3 COLUMNS')('COLUMN3').track.current_x := landscapes('3 COLUMNS')('COLUMN3').start_x;
		landscapes('3 COLUMNS')('COLUMN3').track.current_y := landscapes('3 COLUMNS')('COLUMN3').start_y;

		-- System overview
		landscapes('SYSTEM')('LEFT_TITLE').start_x := width_1_pct * 2;
		landscapes('SYSTEM')('LEFT_TITLE').start_y := height_1_pct * 5;
		landscapes('SYSTEM')('LEFT_TITLE').end_x := width_1_pct * 50;
		landscapes('SYSTEM')('LEFT_TITLE').end_y := height_1_pct * 12;
		landscapes('SYSTEM')('LEFT_TITLE').area# := 1;
		landscapes('SYSTEM')('LEFT_TITLE').area_name := 'System title';
		landscapes('SYSTEM')('LEFT_TITLE').area_font := 'Arial';
		landscapes('SYSTEM')('LEFT_TITLE').area_font_weight := 'normal';
		landscapes('SYSTEM')('LEFT_TITLE').area_font_color := '#000000';
		landscapes('SYSTEM')('LEFT_TITLE').area_font_size := 24;
		landscapes('SYSTEM')('LEFT_TITLE').area_alignment := 'start';
		landscapes('SYSTEM')('LEFT_TITLE').area_data := '';
		landscapes('SYSTEM')('LEFT_TITLE').is_tracked := enable_tracking;
		landscapes('SYSTEM')('LEFT_TITLE').track.current_x := landscapes('SYSTEM')('LEFT_TITLE').start_x;
		landscapes('SYSTEM')('LEFT_TITLE').track.current_y := landscapes('SYSTEM')('LEFT_TITLE').start_y;
		landscapes('SYSTEM')('RIGHT_TITLE').start_x := width_1_pct * 50;
		landscapes('SYSTEM')('RIGHT_TITLE').start_y := height_1_pct * 5;
		landscapes('SYSTEM')('RIGHT_TITLE').end_x := width_1_pct * 98;
		landscapes('SYSTEM')('RIGHT_TITLE').end_y := height_1_pct * 12;
		landscapes('SYSTEM')('RIGHT_TITLE').area# := 1;
		landscapes('SYSTEM')('RIGHT_TITLE').area_name := 'System uptime box';
		landscapes('SYSTEM')('RIGHT_TITLE').area_font := 'Arial';
		landscapes('SYSTEM')('RIGHT_TITLE').area_font_weight := 'normal';
		landscapes('SYSTEM')('RIGHT_TITLE').area_font_color := '#000000';
		landscapes('SYSTEM')('RIGHT_TITLE').area_font_size := 40;
		landscapes('SYSTEM')('RIGHT_TITLE').area_alignment := 'end';
		landscapes('SYSTEM')('RIGHT_TITLE').area_data := '';
		landscapes('SYSTEM')('RIGHT_TITLE').is_tracked := enable_tracking;
		landscapes('SYSTEM')('RIGHT_TITLE').track.current_x := landscapes('SYSTEM')('RIGHT_TITLE').end_x;
		landscapes('SYSTEM')('RIGHT_TITLE').track.current_y := landscapes('SYSTEM')('RIGHT_TITLE').start_y;
		landscapes('SYSTEM')('UPTIME_BAR').start_x := width_1_pct * 2;
		landscapes('SYSTEM')('UPTIME_BAR').start_y := landscapes('SYSTEM')('RIGHT_TITLE').end_y;
		landscapes('SYSTEM')('UPTIME_BAR').end_x := width_1_pct * 98;
		landscapes('SYSTEM')('UPTIME_BAR').end_y := height_1_pct * 25;
		landscapes('SYSTEM')('UPTIME_BAR').area# := 1;
		landscapes('SYSTEM')('UPTIME_BAR').area_name := 'The uptime minutes bar';
		landscapes('SYSTEM')('UPTIME_BAR').area_font := 'Arial';
		landscapes('SYSTEM')('UPTIME_BAR').area_font_weight := 'normal';
		landscapes('SYSTEM')('UPTIME_BAR').area_font_color := '#000000';
		landscapes('SYSTEM')('UPTIME_BAR').area_font_size := 8;
		landscapes('SYSTEM')('UPTIME_BAR').area_alignment := 'start';
		landscapes('SYSTEM')('UPTIME_BAR').area_data := '';
		landscapes('SYSTEM')('UPTIME_BAR').is_tracked := enable_tracking;
		landscapes('SYSTEM')('UPTIME_BAR').track.current_x := landscapes('SYSTEM')('UPTIME_BAR').start_x;
		landscapes('SYSTEM')('UPTIME_BAR').track.current_y := landscapes('SYSTEM')('UPTIME_BAR').start_y;
		landscapes('SYSTEM')('LAYER_LIST').start_x := width_1_pct * 2;
		landscapes('SYSTEM')('LAYER_LIST').start_y := landscapes('SYSTEM')('UPTIME_BAR').end_y;
		landscapes('SYSTEM')('LAYER_LIST').end_x := width_1_pct * 40;
		landscapes('SYSTEM')('LAYER_LIST').end_y := height_1_pct * 98;
		landscapes('SYSTEM')('LAYER_LIST').area# := 1;
		landscapes('SYSTEM')('LAYER_LIST').area_name := 'List of system layers';
		landscapes('SYSTEM')('LAYER_LIST').area_font := 'Arial';
		landscapes('SYSTEM')('LAYER_LIST').area_font_weight := 'normal';
		landscapes('SYSTEM')('LAYER_LIST').area_font_color := '#000000';
		landscapes('SYSTEM')('LAYER_LIST').area_font_size := 14;
		landscapes('SYSTEM')('LAYER_LIST').area_alignment := 'start';
		landscapes('SYSTEM')('LAYER_LIST').area_data := '';
		landscapes('SYSTEM')('LAYER_LIST').is_tracked := enable_tracking;
		landscapes('SYSTEM')('LAYER_LIST').track.current_x := landscapes('SYSTEM')('LAYER_LIST').start_x;
		landscapes('SYSTEM')('LAYER_LIST').track.current_y := landscapes('SYSTEM')('LAYER_LIST').start_y;
		landscapes('SYSTEM')('EVENT_LIST').start_x := landscapes('SYSTEM')('LAYER_LIST').end_x;
		landscapes('SYSTEM')('EVENT_LIST').start_y := landscapes('SYSTEM')('UPTIME_BAR').end_y;
		landscapes('SYSTEM')('EVENT_LIST').end_x := width_1_pct * 98;
		landscapes('SYSTEM')('EVENT_LIST').end_y := height_1_pct * 98;
		landscapes('SYSTEM')('EVENT_LIST').area# := 1;
		landscapes('SYSTEM')('EVENT_LIST').area_name := 'List of events';
		landscapes('SYSTEM')('EVENT_LIST').area_font := 'Arial';
		landscapes('SYSTEM')('EVENT_LIST').area_font_weight := 'bold';
		landscapes('SYSTEM')('EVENT_LIST').area_font_color := '#000000';
		landscapes('SYSTEM')('EVENT_LIST').area_font_size := 14;
		landscapes('SYSTEM')('EVENT_LIST').area_alignment := 'start';
		landscapes('SYSTEM')('EVENT_LIST').area_data := '';
		landscapes('SYSTEM')('EVENT_LIST').is_tracked := enable_tracking;
		landscapes('SYSTEM')('EVENT_LIST').track.current_x := landscapes('SYSTEM')('EVENT_LIST').start_x;
		landscapes('SYSTEM')('EVENT_LIST').track.current_y := landscapes('SYSTEM')('EVENT_LIST').start_y;

		-- Category Summary
		landscapes('CATEGORY SUMMARY')('TITLE').start_x := width_1_pct * 2;
		landscapes('CATEGORY SUMMARY')('TITLE').start_y := height_1_pct * 5;
		landscapes('CATEGORY SUMMARY')('TITLE').end_x := width_1_pct * 98;
		landscapes('CATEGORY SUMMARY')('TITLE').end_y := height_1_pct * 16;
		landscapes('CATEGORY SUMMARY')('TITLE').area# := 1;
		landscapes('CATEGORY SUMMARY')('TITLE').area_name := 'Category title';
		landscapes('CATEGORY SUMMARY')('TITLE').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('TITLE').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('TITLE').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('TITLE').area_font_size := 32;
		landscapes('CATEGORY SUMMARY')('TITLE').area_alignment := 'middle';
		landscapes('CATEGORY SUMMARY')('TITLE').area_data := '';
		landscapes('CATEGORY SUMMARY')('TITLE').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('TITLE').track.current_x := landscapes('CATEGORY SUMMARY')('TITLE').start_x;
		landscapes('CATEGORY SUMMARY')('TITLE').track.current_y := landscapes('CATEGORY SUMMARY')('TITLE').start_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').start_x := width_1_pct * 2;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').start_y := landscapes('CATEGORY SUMMARY')('TITLE').end_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').end_x := width_1_pct * 33.3;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').end_y := height_1_pct * 28;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area# := 1;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_name := 'Circle 1';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_font_size := 32;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_alignment := 'middle';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').area_data := '';
		landscapes('CATEGORY SUMMARY')('CIRCLE1').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').track.current_x := landscapes('CATEGORY SUMMARY')('CIRCLE1').start_x;
		landscapes('CATEGORY SUMMARY')('CIRCLE1').track.current_y := landscapes('CATEGORY SUMMARY')('CIRCLE1').start_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').start_x := width_1_pct * 33.3;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').start_y := landscapes('CATEGORY SUMMARY')('TITLE').end_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').end_x := (width_1_pct * 33.3) + (width_1_pct * 31.3);
		landscapes('CATEGORY SUMMARY')('CIRCLE2').end_y := height_1_pct * 28;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area# := 1;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_name := 'Circle 2';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_font_size := 32;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_alignment := 'middle';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').area_data := '';
		landscapes('CATEGORY SUMMARY')('CIRCLE2').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').track.current_x := landscapes('CATEGORY SUMMARY')('CIRCLE2').start_x;
		landscapes('CATEGORY SUMMARY')('CIRCLE2').track.current_y := landscapes('CATEGORY SUMMARY')('CIRCLE2').start_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').start_x := (width_1_pct * 33.3) + (width_1_pct * 31.3);
		landscapes('CATEGORY SUMMARY')('CIRCLE3').start_y := landscapes('CATEGORY SUMMARY')('TITLE').end_y;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').end_x := width_1_pct * 98;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').end_y := height_1_pct * 28;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area# := 1;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_name := 'Circle 2';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_font_size := 32;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_alignment := 'middle';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').area_data := '';
		landscapes('CATEGORY SUMMARY')('CIRCLE3').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').track.current_x := landscapes('CATEGORY SUMMARY')('CIRCLE3').start_x;
		landscapes('CATEGORY SUMMARY')('CIRCLE3').track.current_y := landscapes('CATEGORY SUMMARY')('CIRCLE3').start_y;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').start_x := width_1_pct * 2;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').start_y := landscapes('CATEGORY SUMMARY')('CIRCLE1').end_y;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').end_x := width_1_pct * 98;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').end_y := height_1_pct * 40;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area# := 1;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_name := 'Category uptime bar';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_font_size := 8;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_alignment := 'start';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').area_data := '';
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').track.current_x := landscapes('CATEGORY SUMMARY')('UPTIME_BAR').start_x;
		landscapes('CATEGORY SUMMARY')('UPTIME_BAR').track.current_y := landscapes('CATEGORY SUMMARY')('UPTIME_BAR').start_y;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').start_x := width_1_pct * 2;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').start_y := landscapes('CATEGORY SUMMARY')('UPTIME_BAR').end_y;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').end_x := width_1_pct * 33.3;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').end_y := height_1_pct * 95;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area# := 1;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_name := 'Summary points';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_font_size := 12;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_alignment := 'start';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').area_data := '';
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').track.current_x := landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').start_x;
		landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').track.current_y := landscapes('CATEGORY SUMMARY')('INCIDENT_SUMMARY').start_y;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').start_x := width_1_pct * 33.3;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').start_y := landscapes('CATEGORY SUMMARY')('UPTIME_BAR').end_y;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').end_x := width_1_pct * 98;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').end_y := height_1_pct * 95;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area# := 1;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_name := 'Summary graph';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_font := 'Arial';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_font_weight := 'normal';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_font_color := '#000000';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_font_size := 12;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_alignment := 'middle';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').area_data := '';
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').is_tracked := enable_tracking;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').track.current_x := landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').start_x;
		landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').track.current_y := landscapes('CATEGORY SUMMARY')('CATEGORY_GRAPH').start_y;

	end init_templates;

	procedure add_defs_to_page (
		page_in			in out		report_page.page
	)

	as

	begin

		page_in.defs('TABLE_HEADER_GRADIENT').def_data := '<linearGradient id="table_header_gradient" x1="0%" y1="0%" x2="0%" y2="100%">
									<stop offset="0%" style="stop-color:rgb(239,239,239);stop-opacity:1" />
									<stop offset="100%" style="stop-color:rgb(232,232,232);stop-opacity:1" />
								    </linearGradient>';

		page_in.defs('SHADOW_SMALL').def_data := '<filter id="shadow_small" width="250%" height="300%">
								<feOffset result="offOut" in="SourceAlpha" dx="1" dy="2"/>
								<feGaussianBlur result="blurOut" in="offOut" stdDeviation="2"/>
								<feBlend in="SourceGraphic" in2="blurOut" mode="normal"/>
							  </filter>';

		page_in.defs('UPTIME_GRADIENT_VERTICAL').def_data := '<linearGradient id="uptime_gradient_vertical" x1="0%" y1="0%" x2="0%" y2="100%">
									<stop offset="0%" style="stop-color:rgb(131,188,134);stop-opacity:1" />
									<stop offset="100%" style="stop-color:rgb(62,125,83);stop-opacity:1" />
								      </linearGradient>';

		page_in.defs('UPTIME_GRADIENT_HORIZONTAL').def_data := '<linearGradient id="uptime_gradient_horizontal" x1="0%" y1="0%" x2="0%" y2="100%">
										<stop offset="0%" style="stop-color:rgb(131,188,134);stop-opacity:1" />
										<stop offset="100%" style="stop-color:rgb(62,125,83);stop-opacity:1" />
									</linearGradient>';

		page_in.defs('DOWNTIME_GRADIENT_HORIZONTAL').def_data := '<linearGradient id="downtime_gradient_horizontal" x1="0%" y1="0%" x2="0%" y2="100%">
										<stop offset="0%" style="stop-color:rgb(214,97,117);stop-opacity:1" />
										<stop offset="100%" style="stop-color:rgb(172,45,67);stop-opacity:1" />
									  </linearGradient>';

		page_in.defs('WARNING_GRADIENT_HORIZONTAL').def_data := '<linearGradient id="warning_gradient_horizontal" x1="0%" y1="0%" x2="0%" y2="100%">
										<stop offset="0%" style="stop-color:rgb(252,241,31);stop-opacity:1" />
										<stop offset="100%" style="stop-color:rgb(216,205,7);stop-opacity:1" />
									 </linearGradient>';

	end add_defs_to_page;

	procedure apply_template (
		page_in			in out		report_page.page,
		template_in		in		varchar2
	)

	as

	begin

		init_templates(page_in.attributes.is_tracked, page_in.dimensions.page_width, page_in.dimensions.page_height);
		if page_in.attributes.orientation = 'portrait' then
			page_in.areas := portraits(template_in);
		elsif page_in.attributes.orientation = 'landscape' then
			page_in.areas := landscapes(template_in);
		end if;

		add_defs_to_page(page_in);

	end apply_template;

end report_templates;
/
