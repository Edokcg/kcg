--剧毒魔
function c77240067.initial_effect(c)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(423585,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77240067.target)
	e3:SetOperation(c77240067.operation)
    c:RegisterEffect(e3)
end
function c77240067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0 end
end
function c77240067.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(2)
        e:GetHandler():RegisterEffect(e1)
	end
end