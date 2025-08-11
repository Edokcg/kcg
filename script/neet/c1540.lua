--护宝炮妖炮台·袭击者号(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),8,2,s.ovfilter,aux.Stringid(id,0))	 
	--attack up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.atkval)
	c:RegisterEffect(e4)
	--Protect itself from destruction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	c:RegisterEffect(e2)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(s.con)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_series={0x158}
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0x158,lc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,lc,SUMMON_TYPE_XYZ,tp) and not c:IsCode(id)
end
function s.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*100
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
end
function s.filter(c)
	return c:IsMonster() and c:IsSetCard(0x158)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local win=false
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=c:GetOverlayGroup():Filter(s.filter,nil)
		if g:GetClassCount(Card.GetCode)>=7 then win=true end
		if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
			if win then Duel.Win(tp,0x0) end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end