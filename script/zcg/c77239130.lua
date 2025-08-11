--青眼究极巨龙(ZCG)
function c77239130.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c77239130.val)
	c:RegisterEffect(e1)

	--攻击
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239130,0)) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)   
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77239130.cost)
	e2:SetCondition(c77239130.condition)
	e2:SetTarget(c77239130.target)
	e2:SetOperation(c77239130.activate)
	c:RegisterEffect(e2)
end
--------------------------------------------------------------------------------
function c77239130.val(e,c)
	local g=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)
	local g1=0  
	if g<3 then
		g1=g1+1
	end
	if g>2 then
		g1=g1+2
	end 
	return g1
end
--------------------------------------------------------------------------------
function c77239130.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239130.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239130.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c77239130.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) then
		local opt=Duel.SelectOption(tp,aux.Stringid(77239130,0),aux.Stringid(77239130,1))
		if opt==0 then
			Duel.NegateAttack()
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)	   
		end 
		
	end
end


