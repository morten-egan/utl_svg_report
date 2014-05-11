create or replace package body report_array

as

	procedure sort_associative_array (
		a_unsorted		in		numlist_charidx_t,
		a_sort			out		numlist_sorter_t
	)

	as

		sort_1			numlist_sorter_t;
		sort_2			numlist_sorter_t;

		unsort_key		varchar2(4000);
		sort1_key		number;
		sort2_key		number;
		not_sorted		boolean := true;

	begin

		unsort_key := a_unsorted.first;
		sort_1(1) := unsort_key;
		unsort_key := a_unsorted.next(unsort_key);
		while unsort_key is not null loop
			if a_unsorted(unsort_key) < a_unsorted(sort_1(sort_1.last)) then
				-- Just plug it in
				sort_1(sort_1.last + 1) := unsort_key;
			elsif a_unsorted(unsort_key) > a_unsorted(sort_1(sort_1.first)) then
				-- Easy re-sort
				sort_2 := sort_1;
				sort_1(1) := unsort_key;
				sort2_key := sort_2.first;
				while sort2_key is not null loop
					sort_1(sort2_key + 1) := sort_2(sort2_key);
					sort2_key := sort_2.next(sort2_key);
				end loop;
			else
				-- Re-arrange
				sort_2 := sort_1;
				sort2_key := sort_2.first;
				while sort2_key is not null loop
					if a_unsorted(unsort_key) < a_unsorted(sort_2(sort2_key)) then
						sort_1(sort2_key) := sort_2(sort2_key);
					elsif (a_unsorted(unsort_key) >= a_unsorted(sort_2(sort2_key))) and not_sorted then
						sort_1(sort2_key) := unsort_key;
						sort_1(sort2_key + 1) := sort_2(sort2_key);
						not_sorted := false;
					else
						sort_1(sort2_key + 1) := sort_2(sort2_key);
					end if;
					sort2_key := sort_2.next(sort2_key);
				end loop;
			end if;
			unsort_key := a_unsorted.next(unsort_key);
			not_sorted := true;
		end loop;

		a_sort := sort_1;

	end sort_associative_array;

end report_array;
/
