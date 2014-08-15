<?php

interface beluga_module_account_Account extends beluga_core_module_Module{
	function subscribe($args);
	function login($args);
	function deleteUser($args);
	function getUser($userId);
	function getSponsor($userId);
	function getUsers();
	function getFriends($user_id);
	function getNotFriends($user_id);
	function getBlackListed($user_id);
	function showUser($args);
	function logout();
	function setLoggedUser($user);
	function getLoggedUser();
	function isLogged();
	function edit($user_id, $email);
	function ban($user_id);
	function unban($user_id);
	function friend($user_id, $friend_id);
	function unfriend($user_id, $friend_id);
	function blacklist($user_id, $friend_id);
	function unblacklist($user_id, $friend_id);
}
