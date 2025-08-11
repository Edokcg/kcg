--天空之神圣骑士 卡珀耳修斯(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x10a),1,s.ffilter,2) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)

	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e) return e:GetHandler():IsInExtraMZone() end)
	e1:SetValue(function(e,re) return e:GetOwnerPlayer()~=re:GetOwnerPlayer() end)
	c:RegisterEffect(e1)
	--Can attack all monsters
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12510878,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
s.listed_names={CARD_SANCTUARY_SKY,id}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end
function s.spcostfilter(c)
	return (c:IsSummonLocation(LOCATION_EXTRA) or c:IsSetCard(0x10a)) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToGraveAsCost()
end
function s.spcostfilter2(c)
	return  c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToGraveAsCost()
end
function s.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0
		and sg:FilterCount(Card.IsSetCard,nil,0x10a)>=1 and sg:FilterCount(s.spcostfilter2,nil,2)>=2
end
function s.envfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_SANCTUARY_SKY)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not (Duel.IsExistingMatchingCard(s.envfilter,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsEnvironment(CARD_SANCTUARY_SKY,tp)) then return end
	local g=Duel.GetMatchingGroup(s.spcostfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return #g>=2 and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spcostfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,1,tp,HINTMSG_TOGRAVE,nil,nil,true)
	if #sg>0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST|REASON_MATERIAL)
	g:DeleteGroup()
end