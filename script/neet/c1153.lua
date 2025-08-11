--狂暴不死龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,s.matfilter,1,1,s.matfilter2,1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.atkcon)
	e5:SetValue(s.atkval)
	c:RegisterEffect(e5)
end
s.material={33420078}
s.listed_names={33420078}
function s.matfilter(c,fc,sumtype,tp)
	return aux.FilterSummonCode(33420078) or Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
end
function s.matfilter2(c,fc,sumtype,tp)
	return c:IsRace(RACE_ZOMBIE) or Duel.GetFieldGroupCount(tp,LOCATION_EMZONE,0)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.filter(c,tp)
	local p=c:GetControler()
	return c:IsFaceup() and c:GetSequence()>4 and Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local tc=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp):GetFirst()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE,tc:GetControler(),LOCATION_REASON_CONTROL)>0 then
		local p1,p2,i
		if tc:IsControler(tp) then
			i=0
			p1=LOCATION_MZONE
			p2=0
		else
			i=16
			p2=LOCATION_MZONE
			p1=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)-i)
	end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function s.atkcon(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)>0
end
function s.atkval(e)
	local c=e:GetHandler()
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)
end