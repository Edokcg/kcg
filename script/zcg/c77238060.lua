--碎魂者之外敌搜索队(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
		  --recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
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
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=10 end
end
function s.filter(c,e,tp,ft)
	return c:IsSetCard(0xa70)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,10)
	if #g==10 then
		Duel.ConfirmDecktop(1-tp,10)
		local tg=g:Filter(s.filter,nil,e,tp,ft)
		if #tg>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
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













