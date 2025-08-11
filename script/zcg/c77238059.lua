--碎魂者之攻击转移(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
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
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not re:IsActiveType(TYPE_SPELL) or re:GetHandlerPlayer()==tp then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	return true 
end
function s.evfilter(c,ev)
	return Duel.CheckChainTarget(ev,c)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local evg=Duel.GetMatchingGroup(s.evfilter,tp,0x1ff,0x1ff,nil,ev)
	if evg:GetCount()<=0 then return end
	Duel.ConfirmCards(tp,evg)
	local tc=evg:Select(tp,1,1,nil)
	local g=Group.CreateGroup()
	g:AddCard(tc)
	Duel.ChangeTargetCard(ev,g)
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






