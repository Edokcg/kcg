--奥利哈刚 盔甲巴龙 （ZCG）
function c77240262.initial_effect(c)
				--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c77240262.etarget)
	e3:SetValue(c77240262.efilter)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240262,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(c77240262.tgtg)
	e4:SetOperation(c77240262.tgop)
	c:RegisterEffect(e4)
end
function c77240262.etarget(e,c)
	return c:IsSetCard(0xa50) and c:IsType(TYPE_MONSTER)
end
function c77240262.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c77240262.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c77240262.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,LOCATION_HAND,1,4,nil)
	if g:GetCount()>0 then
		 local atk=Duel.SendtoGrave(g,REASON_EFFECT)
		 local c=e:GetHandler()
		 local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(atk*1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			e3:SetValue(atk*600)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e3)
	end
end