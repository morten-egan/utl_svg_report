create or replace package report_array 

as

	type numlist_charidx_t is table of number index by varchar2(500);
	type numlist_sorter_t is table of varchar2(500) index by pls_integer;

	procedure sort_associative_array (
		a_unsorted		in		numlist_charidx_t,
		a_sort			out		numlist_sorter_t
	);

end report_array;
/
