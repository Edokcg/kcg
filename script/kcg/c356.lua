--反-希望 絶望神 (K)
Duel.EnableUnofficialProc(PROC_CANNOT_BATTLE_INDES)
local s, id = GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BATTLE_INDES)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(s.battg)
	e5:SetValue(s.batval)
	c:RegisterEffect(e5)

	-- local e9=Effect.CreateEffect(c)
	-- e9:SetProperty(EFFECT_FLAG_INITIAL)
	-- e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	-- e9:SetCode(EVENT_BATTLED)
	-- e9:SetRange(LOCATION_MZONE)
	-- e9:SetCondition(s.con)
	-- e9:SetOperation(s.op)
	-- c:RegisterEffect(e9)
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end

function s.battg(e,c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.batval(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.con(e)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local bc=c:GetBattleTarget()
	if not bc then return end
	local bct=0
	if bc:GetPosition()==POS_FACEUP_ATTACK then
		bct=bc:GetAttack()
	else bct=bc:GetDefense()+1 end
	return c:IsRelateToBattle() and c:GetPosition()==POS_FACEUP_ATTACK 
	 and atk>=bct and not bc:IsStatus(STATUS_BATTLE_DESTROYED)
end 
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	Duel.Destroy(bc,REASON_RULE)
	bc:SetStatus(STATUS_BATTLE_DESTROYED,true)
end
