--SNo. 閃光超量體
local s, id = GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id,1))
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_DISABLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(function(...)
        return Duel.GetLP(e:GetHandlerPlayer()) >= 1000
    end)
    c:RegisterEffect(e8, true)
    local e82 = e8:Clone()
    e82:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e82, true)

    -- battle indestructable
    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e0:SetValue(aux.NOT(aux.TargetBoolFunction(Card.IsSetCard, 0x48)))
    c:RegisterEffect(e0)

    --attack up
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cost.AND(Cost.DetachFromSelf(function(e) return e:GetHandler():GetOverlayCount() end),function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c=e:GetHandler()
        if chk==0 then return Duel.GetLP(tp)>1 end
        Duel.SetLP(tp,1)
    end))
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
        local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
        if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
            local sum=Duel.GetOperatedGroup():GetSum(Card.GetAttack)
            Duel.Damage(1-tp,sum,REASON_EFFECT)
        end
    end)
    c:RegisterEffect(e1,true)

end
s.listed_series = {0x48}
