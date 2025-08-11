--红通通☆奥西里斯的天空龙
function c77239799.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c77239799.spcon)
	e1:SetOperation(c77239799.spop)
	c:RegisterEffect(e1)
	
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c77239799.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)	

	--unaffectable
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetDescription(aux.Stringid(77239799,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c77239799.cost)
	e4:SetOperation(c77239799.operation)
	c:RegisterEffect(e4)
	
	--DESTROY
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetDescription(aux.Stringid(77239799,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c77239799.cost)
	e5:SetTarget(c77239799.target)
	e5:SetOperation(c77239799.activate)
	c:RegisterEffect(e5)	
	
	--TOGRAVE
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetDescription(aux.Stringid(77239799,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c77239799.cost)
	e6:SetTarget(c77239799.totg)
	e6:SetOperation(c77239799.toop)
	c:RegisterEffect(e6)	
end
----------------------------------------------------------------------
function c77239799.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.CheckLPCost(tp,500)
	and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_EXTRA,0,2,nil,0x48)
end
function c77239799.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_EXTRA,0,2,2,nil,0x48) 
	if g:GetCount()>0 then
		local tc=g:GetFirst()   
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		g:RemoveCard(tc)
		Duel.Overlay(tc,g)
		Duel.Overlay(c,g)	   
		Duel.Overlay(c,tc)  
	end 
end
----------------------------------------------------------------------
function c77239799.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*4000
end
----------------------------------------------------------------------
function c77239799.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239799.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c77239799.efilter)
		c:RegisterEffect(e4)
	end
end
function c77239799.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------
function c77239799.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239799.filter,tp,0,LOCATION_MZONE,2,nil) end
	local g=Duel.GetMatchingGroup(c77239799.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
end
function c77239799.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77239799.filter,tp,0,LOCATION_MZONE,2,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local sg=Duel.Destroy(g,REASON_EFFECT)
		if sg>0 then
			atk=g:GetSum(Card.GetAttack)
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
----------------------------------------------------------------------
function c77239799.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_EXTRA,1,nil,0x48) end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_EXTRA,nil,0x48)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c77239799.toop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_ONFIELD+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_EXTRA,1,1,nil,0x48)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
	end
end
