--DB-乌龙-魔法变身
function c77240021.initial_effect(c)
    --destroy replace
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EFFECT_DESTROY_REPLACE)
    e5:SetRange(LOCATION_HAND)
    e5:SetTarget(c77240021.reptg)
    e5:SetValue(c77240021.repval)
    c:RegisterEffect(e5)
end
function c77240021.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
	and c:IsReason(REASON_BATTLE)
end
function c77240021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c77240021.repfilter,1,nil,tp) end
    if e:GetHandler():IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(77240021,0)) then
        Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
        local g=eg:Filter(c77240021.repfilter,nil,tp)
        if g:GetCount()==1 then
            e:SetLabelObject(g:GetFirst())
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
            local cg=g:Select(tp,1,1,nil)
            e:SetLabelObject(cg:GetFirst())
        end
        return true
    else return false end
end
function c77240021.repval(e,c)
    return c==e:GetLabelObject()
end