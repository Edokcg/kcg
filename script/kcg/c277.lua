--狂戦士の魂
function c277.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6330307,1))
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c277.dacon)
	e2:SetCost(c277.cost)
	e2:SetTarget(c277.tar2)
	e2:SetOperation(c277.acti2)
	c:RegisterEffect(e2)	
end

function c277.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=nil and Duel.GetAttacker():GetControler()==e:GetHandler():GetControler()
	and Duel.GetAttacker():GetAttack()<=1500
end
function c277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		g:RemoveCard(e:GetHandler())
		return g:GetCount()>0 and g:FilterCount(Card.IsDiscardable,nil)==g:GetCount()
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c277.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():CanAttack() end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c277.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker()~=nil and Duel.GetAttacker():GetControler()==e:GetHandler():GetControler() and Duel.GetAttacker()==e:GetLabelObject()
		and Duel.GetAttacker():GetAttack()<=1500 and Duel.GetAttacker():GetFlagEffect(277)~=0 and Duel.GetAttacker():CanAttack() end
	Duel.SetTargetCard(Duel.GetAttacker())
end
function c277.acti2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFirstTarget()
	if e:GetHandler():GetFlagEffect(277)==0 then
		Duel.Hint(HINT_BGM, tp, aux.Stringid(828, 2))
	end
	if a:IsRelateToBattle() and a:GetControler()==tp and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)		
		if tc:IsType(TYPE_MONSTER) then  
			if a:GetFlagEffect(277)==3 then 
				Duel.Hint(HINT_BGM, tp, aux.Stringid(828, 4))
			else 
				if a:GetFlagEffect(277)<3 then 
					Duel.Hint(HINT_MUSIC, tp, aux.Stringid(828, 3))
				end
			end	
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then  			 
				Duel.ChainAttack()
				a:RegisterFlagEffect(277,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
				e:GetHandler():CancelToGrave()  
				if e:GetHandler():GetFlagEffect(277)==0 then 
					e:GetHandler():RegisterFlagEffect(277,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)	
					e3:SetCode(EVENT_BATTLED)
					e3:SetRange(LOCATION_SZONE)
					e3:SetLabelObject(a)
					e3:SetTarget(c277.tar3)
					e3:SetOperation(c277.acti2)
					e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
					e:GetHandler():RegisterEffect(e3)

					local e5=Effect.CreateEffect(e:GetHandler())
					e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)	
					e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
					e5:SetRange(LOCATION_SZONE)
					e5:SetCountLimit(1)
					e5:SetOperation(c277.acti0)
					e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
					e:GetHandler():RegisterEffect(e5)

					local e18=Effect.CreateEffect(c)
					e18:SetType(EFFECT_TYPE_FIELD)
					e18:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e18:SetCode(EFFECT_CANNOT_LOSE_LP)
					e18:SetRange(LOCATION_SZONE)
					e18:SetTargetRange(0,1)
					e18:SetValue(1)
					e18:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
					c:RegisterEffect(e18)	
				end
			end
		else 
			Duel.ShuffleHand(tp) 
			Duel.SendtoGrave(e:GetHandler(),REASON_RULE) 
		end
	end
end

function c277.acti0(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
end
