--狂歧蜥·魔蜥义豪（neet）
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2)
end