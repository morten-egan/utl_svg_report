create or replace package report_debug

as

	procedure dump_page_to_screen (
		page_in			in		report_page.page
	);

	procedure dump_page_debug_to_screen (
		page_in			in		report_page.page
	);

end report_debug;
/
