--地狱之降雷皇 哈蒙
function c77239897.initial_effect(c)
    c:EnableReviveLimit()
    --[[cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)]]
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e2)
	
    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetTarget(c77239897.targ)
    e3:SetOperation(c77239897.op)
    c:RegisterEffect(e3)
	
    --Destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(c77239897.desreptg)
    c:RegisterEffect(e4)
end
-----------------------------------------------------------------------
function c77239897.targ(e,tp,eg,ep,ev,re,r,rp,chk)
    local d=Duel.GetAttackTarget()
    if chk ==0 then return Duel.GetAttacker()==e:GetHandler()
        and d~=nil and d:IsFaceup() and  d:IsDestructable() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c77239897.op(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    if d~=nil and d:IsRelateToBattle() then
	    local atk=0
		local dam=0
		if d:IsFaceup() and e:GetHandler():GetAttack()>d:GetAttack() then
			atk=atk+d:GetAttack()
			dam=e:GetHandler():GetAttack()-d:GetAttack()
		end
        local ct=Duel.Destroy(d,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		if dam>0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
		if ct>0 and atk>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		    local op=Duel.SelectOption(tp,aux.Stringid(77239897,0),aux.Stringid(77239897,1))			
			if op==0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(d:GetAttack())
				e:GetHandler():RegisterEffect(e1)
			else
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(d:GetDefense())
				e:GetHandler():RegisterEffect(e1)
			end
		end
    end
end
-----------------------------------------------------------------------
function c77239897.repfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c77239897.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) 
        and Duel.IsExistingMatchingCard(c77239897.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(77239897,2)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c77239897.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
        return true
    else return false end
end







