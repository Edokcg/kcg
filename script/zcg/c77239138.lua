--青眼反射龙
function c77239138.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcCodeRep(c,89631139,2,true,true)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)   
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c77239138.target)
	e1:SetOperation(c77239138.activate)
	c:RegisterEffect(e1)	
end

function c77239138.filter(c)
	return c:IsFaceup()
end
function c77239138.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c77239138.filter,tp,0,LOCATION_MZONE,1,nil,lp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c77239138.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239138.filter,tp,0,LOCATION_MZONE,1,3,nil)
	local tc=g:GetFirst()
	local dam=0
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		dam=dam+atk
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,dam,REASON_EFFECT)		 
end