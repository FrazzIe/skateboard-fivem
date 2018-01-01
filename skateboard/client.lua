local skateboard_car = nil
local skateboard = nil
local function EquipSkateboard()
	Citizen.CreateThread(function()
		local model = GetHashKey("p_defilied_ragdoll_01_s")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_BAT"), 0, true, true)

		skateboard = CreateObject(model, GetEntityCoords(PlayerPedId(), false), false, false, false)
		local weapon_obj = GetWeaponObjectFromPed(PlayerPedId(), 1)
		AttachEntityToEntity(skateboard, weapon_obj, 0, -0.05, 0.0, 0.3, 180.0, 90.0, 0.0, false, false, false, false, 2, true)
		AttachEntityToEntity(weapon_obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.08, 0.0, 0.0, -85.0, 22.0, 0.0, false, false, false, false, 2, true)
		SetPedCurrentWeaponVisible(PlayerPedId(), false, true, 0, 0)
		SetPedCanSwitchWeapon(PlayerPedId(), false)
	end)
end

local function UnequipSkateboard()
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), 0, true, true)
	DeleteObject(skateboard)
	SetPedCanSwitchWeapon(PlayerPedId(), true)
end

local function StartSkating()
	Citizen.CreateThread(function()
		SetEntityAlpha(PlayerPedId(), 0)
		RequestModel(1131912276)
		while not HasModelLoaded(1131912276) do
			Citizen.Wait(0)
		end
		skateboard_car = CreateVehicle(1131912276, GetEntityCoords(PlayerPedId(), false), GetEntityHeading(PlayerPedId()), true, false)
		SetEntityInvincible(skateboard_car, true)
		SetEntityAlpha(skateboard_car, 0)
		local fakeskater = ClonePed(PlayerPedId(), GetEntityHeading(PlayerPedId()), false, true)
		TaskPlayAnim(fakeskater, "move_strafe@stealth", "idle", 8.0, -4.0, -1, 9, 0.0, false, false, false)
		AttachEntityToEntity(fakeskater,skateboard_car, 0, 0.0, 0.0, 0.75, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		SetEntityCollision(fakeskater, false, true)
		SetBlockingOfNonTemporaryEvents(fakeskater, true)
		SetEntityInvincible(fakeskater, true)
		local model = GetHashKey("p_defilied_ragdoll_01_s")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		skateboard = CreateObject(model, GetEntityCoords(PlayerPedId(), false), false, false, false)
		AttachEntityToEntity(skateboard,skateboard_car, 0, 0.0, 0.0, -0.4, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
		SetPedIntoVehicle(PlayerPedId(), skateboard_car, -1)
	end)
end
Citizen.CreateThread(function()
	RequestAnimDict("move_strafe@stealth")
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 51) then
			--EquipSkateboard()
			StartSkating()
		end
	end
end)
SetPedCanSwitchWeapon(PlayerPedId(), true)
RemoveAllPedWeapons(PlayerPedId(), 0)