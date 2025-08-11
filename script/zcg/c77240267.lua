--装甲 特种战斗兵 （ZCG）
function c77240267.initial_effect(c)
	 --disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c77240267.sumlimit)
	c:RegisterEffect(e1)
	--Special summon2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240267,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c77240267.spcon2)
	e3:SetTarget(c77240267.target)
	e3:SetOperation(c77240267.activate)
	c:RegisterEffect(e3)
end
function c77240267.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttack()>=1800
end
function c77240267.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c77240267.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77240267.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240267.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,c) end
	local sg=Duel.GetMatchingGroup(c77240267.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240267.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240267.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	if ct>0 then 
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end
end







