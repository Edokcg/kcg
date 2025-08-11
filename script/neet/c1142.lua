--伪十二兽 猫魂（neet）
local s,id=GetID()
function s.initial_effect(c)
		--xyz summon
	Xyz.AddProcedure(c,nil,4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(s.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.descost)
	e3:SetCondition(s.atkcon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
s.listed_series={0xf1}
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard(0xf1,lc,SUMMON_TYPE_XYZ,tp) and not c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,id)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
function s.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function s.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function s.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function s.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(s.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkfilter1(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.atkfilter1,1,nil,nil,1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Destroy(eg,REASON_EFFECT)
end