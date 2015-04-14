-- 4.1.0.1.1-4.1.0.1.2.sql
SELECT acs_log__debug('/packages/intranet-wiki/sql/postgresql/upgrade/upgrade-4.1.0.1.1-4.1.0.1.2.sql','');


-- Disable Wiki menu if no wiki is installed
update im_menus
set visible_tcl = '[im_package_exists_p wiki]'
where label = 'wiki';




create or replace function inline_0 ()
returns integer as $$
declare
	v_menu			integer;
	v_main_menu		integer;
	v_employees		integer;
	v_customers		integer;
	v_freelancers		integer;
BEGIN
	select group_id into v_employees from groups where group_name = 'Employees';
	select group_id into v_customers from groups where group_name = 'Customers';
	select group_id into v_freelancers from groups where group_name = 'Freelancers';
	select menu_id into v_main_menu from im_menus where label='main';

	v_menu := im_menu__new (
		null,				-- p_menu_id
		'im_menu',			-- object_type
		now(),				-- creation_date
		null,				-- creation_user
		null,				-- creation_ip
		null,				-- context_id
		'intranet-wiki',		-- package_name
		'xowiki',			-- label
		'XoWiki',			-- name
		'/xowiki/',			-- url
		76,				-- sort_order
		v_main_menu,			-- parent_menu_id
		'[im_package_exists xowiki]'	-- p_visible_tcl
	);

	PERFORM acs_permission__grant_permission(v_menu, v_employees, 'read');
	PERFORM acs_permission__grant_permission(v_menu, v_customers, 'read');
	PERFORM acs_permission__grant_permission(v_menu, v_freelancers, 'read');

	return 0;
end;$$ language 'plpgsql';
select inline_0 ();
drop function inline_0 ();


