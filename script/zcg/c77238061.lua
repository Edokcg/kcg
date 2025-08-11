--碎魂者之同伴的支援(ZCG)
local s,id=GetID()
function s.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e93=Effect.CreateEffect(c)
	e93:SetType(EFFECT_TYPE_FIELD)
	e93:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e93:SetCode(EFFECT_FORBIDDEN)
	e93:SetRange(LOCATION_SZONE)
	e93:SetTargetRange(0,0xff)
	e93:SetTarget(s.bantg93)
	c:RegisterEffect(e93)
	local e94=Effect.CreateEffect(c)
	e94:SetType(EFFECT_TYPE_SINGLE)
	e94:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e94:SetRange(LOCATION_SZONE)
	e94:SetCode(EFFECT_IMMUNE_EFFECT)
	e94:SetValue(s.efilter94)
	c:RegisterEffect(e94)
	--
	local e95 = Effect.CreateEffect(c)
	e95:SetType(EFFECT_TYPE_FIELD)
	e95:SetCode(EFFECT_DISABLE)
	e95:SetRange(LOCATION_SZONE)
	e95:SetTargetRange(0, LOCATION_ONFIELD)
	e95:SetTarget(s.distg95)
	c:RegisterEffect(e95)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_ADJUST)
	e103:SetRange(LOCATION_SZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
end
function s.dafilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa160)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(s.dafilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return gc>0 and Duel.IsPlayerCanDraw(tp,gc) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(gc)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.efilter94(e,te)
	return te:GetHandler():IsSetCard(0xa70)
end
function s.bantg93(e,c)
	return c:IsSetCard(0xa70) and (not c:IsOnField() or c:GetRealFieldID()>e:GetFieldID())
end
function s.distg95(e, c)
	return c:IsSetCard(0xa70)
end
function s.filter96(c)
	return c:IsSetCard(0xa70)
end
function s.filter99(c)
	return c:IsSetCard(0xa70) and c:IsFaceup()
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.filter99,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	end
end




