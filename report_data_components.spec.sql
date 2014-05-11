create or replace package report_data_components

as

	type bar_graph_list is table of number index by varchar2(4000);
	type line_graph_list is table of number index by varchar2(4000);

	procedure report_line_graph (
		report_object		in out	report_create.report,
		area_name			in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_data			in		line_graph_list,
		graph_height		in		number default null,
		graph_width			in		number default null
	);

	procedure page_line_graph (
		page_in				in out	report_page.page,
		area_name			in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_data			in		line_graph_list,
		graph_height		in		number default null,
		graph_width			in		number default null
	);

	procedure page_bar_graph (
		page_in				in out	report_page.page,
		area_name			in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_orientation	in		varchar2 default 'vertical',
		graph_data			in		bar_graph_list,
		graph_height		in		number default null,
		graph_width			in		number default null
	);

	procedure report_bar_graph (
		report_object		in out	report_create.report,
		area_name			in		varchar2 default null,
		area_fill_type		in		varchar2 default 'full',
		graph_orientation	in		varchar2 default 'vertical',
		graph_data			in		bar_graph_list,
		graph_height		in		number default null,
		graph_width			in		number default null
	);

end report_data_components;
/
