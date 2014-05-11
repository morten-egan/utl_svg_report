create or replace package report_defaults

as

	-- Colors
	def_color_border			varchar2(250)		:= '#000000';
	def_color_fill				varchar2(250)		:= '#FFFFFF';
	def_color_line				varchar2(250)		:= '#000000';

	-- Sizes
	def_size_border_width		number				:= 1; -- Unit type
	def_size_corner_rounding	number				:= 5; -- Unit type
	def_size_box_padding		number				:= 5; -- Percent
	def_size_line_width			number				:= 1; -- Unit type
	def_size_header_height		number				:= 4; -- Percent
	def_size_footer_height		number				:= 4; -- Percent

	-- Page defaults
	def_page_left_margin		number				:= 2; -- Percent
	def_page_right_margin		number				:= 2; -- Percent

end report_defaults;
/
