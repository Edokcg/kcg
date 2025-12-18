--降雷皇 哈蒙
local s, id = GetID()
function s.initial_effect(c)
	aux.god(c,1,id,0)

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(805)
    e0:SetValue(1)
    c:RegisterEffect(e0)

	c:EnableReviveLimit()
	
	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--战破怪兽时对方扣LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10000014,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	
	--Protect other Monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(s.protectcon)
	e3:SetTarget(s.protecttg)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--表侧守备状态被破坏回合自己伤害为0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.nocon)
	e4:SetOperation(s.noop)
	c:RegisterEffect(e4)

	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_THUNDER)
	c:RegisterEffect(e114)
	local e115=e114:Clone()
	e115:SetCode(EFFECT_ADD_ATTRIBUTE)
	e115:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e115)
end
---------------------------------------------------------------------------------------------------------------
function s.spfilter(c)
	return c:IsType(TYPE_SPELL) and not c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end

function s.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	else
		return Duel.IsExistingMatchingCard(s.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	end
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD,0,2,2,g1:GetFirst())
		g2:AddCard(g1:GetFirst())
			local tc=g2:GetFirst()
			while tc do
			if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
			tc=g2:GetNext() end
		Duel.SendtoGrave(g2,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
			local tc2=g:GetFirst()
			while tc2 do
			if tc2:IsFacedown() then Duel.ConfirmCards(tp,tc2) end
			tc2=g:GetNext() end
		Duel.SendtoGrave(g,REASON_COST)
	end
end
------------------------------------------------------------------------------------------------------------------
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
-----------------------------------------------------------------------------------------------------------
function s.protectcon(e)
	return e:GetHandler():IsDefensePos()
end
function s.protecttg(e,c)
	return c~=e:GetHandler()
end

function s.nocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP_DEFENSE) and c:IsReason(REASON_DESTROY)
end

function s.noop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end