<?php

interface beluga_module_account_Account extends beluga_core_module_Module{
	function subscribe($args);
	function login($args);
	function deleteUser($args);
	function getUser($userId);
	function getUsers();
	function showUser($args);
	function logout();
	function setLoggedUser($user);
	function getLoggedUser();
	function isLogged();
	function edit($user_id, $email);
}
