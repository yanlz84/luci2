module("luci.controller.ipsec-server", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ipsec") then
		return
	end

	local page = entry({"admin", "vpn"}, firstchild(), "VPN", 45)
	page.dependent = false
	page.acl_depends = { "luci-app-ipsec-vpnd" }

	entry({"admin", "vpn", "ipsec-server"}, cbi("ipsec-server"), _("IPSec VPN Server"), 80)
	entry({"admin", "vpn", "ipsec-server", "status"}, call("act_status")).leaf = true
end

function act_status()
	local e = {}
	e.running = luci.sys.call("pgrep ipsec >/dev/null") == 0
	luci.http.prepare_content("application/json")
	luci.http.write_json(e)
end
