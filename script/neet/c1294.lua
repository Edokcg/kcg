--闪刀姬-钢蕾
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,12421694,aux.FilterBoolFunction(s.ffilter),1,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	--cannot link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetCondition(s.linkcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--decrease atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.atkcon)
	e4:SetTarget(s.atktg)
	e4:SetValue(s.atkval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(s.atkval2)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.discon)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e8:SetValue(LOCATION_REMOVED)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1115))
	c:RegisterEffect(e8)
end
function s.linkcon(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) 
end
function s.ffilter(c)
	return not c:IsAttribute(ATTRIBUTE_EARTH) and  c:IsSetCard(0x1115)   
end
function s.chainfilter(re,tp)
	return not (re:GetHandler():IsSetCard(0x115)) and re:IsActiveType(TYPE_SPELL)
end
function s.ffilter1(c)
	return c:IsCode(12421694) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function s.rfilter(c,fc)
	return (s.ffilter1(c) or (not c:IsAttribute(ATTRIBUTE_EARTH) and  c:IsSetCard(0x1115)))
		and c:IsCanBeFusionMaterial(fc) and c:IsAbleToRemoveAsCost()
end
function s.spfilter1(c,tp,g)
	return g:IsExists(s.spfilter2,1,c,tp,c)
end
function s.spfilter2(c,tp,mc)
	return (s.ffilter1(c) and (not mc:IsAttribute(ATTRIBUTE_EARTH) and  mc:IsSetCard(0x1115))
		or s.ffilter1(mc) and (not c:IsAttribute(ATTRIBUTE_EARTH) and  c:IsSetCard(0x1115)))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	return rg:IsExists(s.spfilter1,1,nil,tp,rg) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)~=0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=rg:FilterSelect(tp,s.spfilter1,1,1,nil,tp,rg)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:FilterSelect(tp,s.spfilter2,1,1,mc,tp,mc)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function s.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function s.atktg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.atkval1(e,c)
	return c:GetBaseAttack()
end
function s.atkval2(e,c)
	return c:GetBaseDefense()
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1115) and c:IsControler(tp)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and s.cfilter(c,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(s.discon2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetCondition(s.discon2)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end
function s.discon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end