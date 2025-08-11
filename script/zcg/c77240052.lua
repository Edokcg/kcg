--恶魔神王巴隆迪亚兹
function c77240052.initial_effect(c)
    --xyz summon
    Xyz.AddProcedure(c,nil,10,3)
    c:EnableReviveLimit()
    --破坏
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c77240052.tdcon)
    e1:SetTarget(c77240052.target)
    e1:SetOperation(c77240052.activate)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1)
    e2:SetCost(c77240052.tgcost)
    e2:SetOperation(c77240052.tgop)
    c:RegisterEffect(e2)	
end
--------------------------------------------------------------------
function c77240052.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77240052.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240052.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
    Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------------
function c77240052.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77240052.tgop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c77240052.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77240052.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

