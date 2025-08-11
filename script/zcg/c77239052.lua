--炎狱龙
function c77239052.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239052.ttcon)
	e1:SetOperation(c77239052.ttop)
	--e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_LIMIT_SET_PROC)
    e5:SetCondition(c77239052.setcon)
    c:RegisterEffect(e5)
	
	--攻击时不能发动效果
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c77239052.aclimit)
    e2:SetCondition(c77239052.actcon)
    c:RegisterEffect(e2)	
	
    --攻防提升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c77239052.value)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)	
	
end
----------------------------------------------------------------------
function c77239052.setcon(e,c,minc)
    if not c then return true end
    return false
end
function c77239052.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239052.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
    local s=0
	if g:IsExists(Card.IsRace,3,nil,RACE_DRAGON) then
		s=s+1	
		local e2=Effect.CreateEffect(c)	
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)			
		e2:SetTarget(c77239052.target)
		e2:SetOperation(c77239052.activate)
		c:RegisterEffect(e2)
		
	elseif g:IsExists(Card.IsRace,2,nil,RACE_DRAGON) and s<1 then
	    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PIERCE)
        c:RegisterEffect(e1)
	end
end
function c77239052.filter(c)
	return c:IsDestructable()
end
function c77239052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239052.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239052.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239052.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239052.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
---------------------------------------------------------------------------
function c77239052.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c77239052.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
---------------------------------------------------------------------------
function c77239052.spfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER)
end
function c77239052.value(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(c77239052.spfilter,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)*300
end
---------------------------------------------------------------------------

