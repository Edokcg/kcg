--奥利哈刚 红蛇女(ZCG)
function c77240076.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    Fusion.AddProcCodeRep(c,77239214,2,true,true)
	
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77240076,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCost(c77240076.cost)
    e1:SetOperation(c77240076.spop)
    c:RegisterEffect(e1)
end

function c77240076.costfilter(c)
    return c:IsDestructable()
end
function c77240076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240076.costfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
end
function c77240076.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,c77240076.costfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,10,nil)
    e:SetLabel(g:GetCount())
    Duel.Destroy(g,REASON_EFFECT)
	local ct=e:GetLabel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		e:GetHandler():RegisterEffect(e1)
end