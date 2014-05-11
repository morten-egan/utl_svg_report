create or replace package report_templates

as

	procedure apply_template (
		page_in			in out	report_page.page,
		template_in		in		varchar2
	);

end report_templates;
/
