--冥界守护者 淮德拉(ZCG)
function c77239059.initial_effect(c)
    --Atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c77239059.tg)
    e2:SetCondition(c77239059.con)
    e2:SetValue(3000)
    c:RegisterEffect(e2)

    --must attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCode(EFFECT_MUST_ATTACK)
    e3:SetCondition(c77239059.con)
    c:RegisterEffect(e3)
end
--------------------------------------------------------------------------------------
function c77239059.tg(e,c)
    return c:IsFaceup() and c:IsSetCard(0xa13)--[[(c:IsCode(77239058) or c:IsCode(77239059) or c:IsCode(77239046) or c:IsCode(77239047) or c:IsCode(77239050)
	 or c:IsCode(8198620) or c:IsCode(21435914) or c:IsCode(22657402) or c:IsCode(53982768) or c:IsCode(66547759) or c:IsCode(75043725)
	 or c:IsCode(89272878) or c:IsCode(89732524) or c:IsCode(96163807))]]
end
function c77239059.con(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
