--毒黄蛇
function c77240051.initial_effect(c)
    --cannot special summon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(c77240051.condition2)
    e3:SetTarget(c77240051.target2)
    e3:SetOperation(c77240051.operation2)
    c:RegisterEffect(e3)
end
---------------------------------------------------------------------
function c77240051.condition2(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c77240051.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,5) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(5)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5)
end
function c77240051.operation2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
    local g=Duel.GetOperatedGroup()	
    Duel.ConfirmCards(1-p,g)
    local dg=g:Filter(c77240051.filter,nil,e,tp)
    if dg:GetCount()>0 then
        Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
    end	
    g:Sub(dg)	
    Duel.SendtoGrave(g,REASON_EFFECT)	
    Duel.ShuffleHand(p)	
end
function c77240051.filter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
---------------------------------------------------------------------

