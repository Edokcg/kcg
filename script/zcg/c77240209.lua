--殉道者 地狱指示女神（ZCG）
local m=77240209
local cm=_G["c"..m]
function c77240209.initial_effect(c)
	 --disable zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.zcost)
	e2:SetTarget(cm.ztg)
	e2:SetOperation(cm.zop)
	c:RegisterEffect(e2)
  --disable zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.condition2)
	e3:SetCost(cm.zcost)
	e3:SetTarget(cm.ztg2)
	e3:SetOperation(cm.zop)
	c:RegisterEffect(e3)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(cm.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(cm.distg9)
	c:RegisterEffect(e12)
end
function cm.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function cm.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function cm.cfilter(c,ft,tp)
	return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_SZONE,1,nil)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_SZONE,1,nil)
end
function cm.zcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>2 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.ztg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0xe000e0)
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.zop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(zone)
	--e:GetHandler():RegisterEffect(e1)
	Duel.RegisterEffect(e1,tp)
end