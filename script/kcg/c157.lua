local s, id = GetID()
function s.initial_effect(c)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetLP(tp)>1 end
	e:GetHandler():RemoveOverlayCard(tp,g,g,REASON_COST)
	Duel.SetLP(tp,1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local sg2=Duel.GetMatchingGroup(s.ovfilter2,tp,0,LOCATION_MZONE,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#sg2*1000)
end
function s.ovfilter2(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
    if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)>0 then
        Duel.BreakEffect()
        local g=Duel.GetOperatedGroup()
        Duel.Damage(1-tp,#g*1000,REASON_EFFECT) 
    end
end

function aux.rfilter(c)
    return c:IsFaceup() and c:GetAttack() > 0
end

function s.xyzfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function s.filter2(c, e, tp)
    local no = c.xyz_number
    return no and no >= 101 and no <= 107 and c:IsSetCard(0x1048)
end

function s.chk(c, code)
    return c:GetCode() == code
end
function s.astral(c)
    return c:IsType(TYPE_XYZ) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x1073) and
               Duel.GetMatchingGroupCount(s.astral2, c:GetControler(), LOCATION_EXTRA, 0, c, c:GetOriginalCode()) ==
               0
end
function s.astral2(c, code)
    return c:IsType(TYPE_XYZ) and not c:IsSetCard(0x1048) and not c:IsSetCard(0x1073) and c:GetOriginalCode() == code
end
function s.rankfiler(c)
    return c:GetRank() >= 10 and c:IsFaceup()
end
function s.costfilter(c, code)
    return c:GetCode() == code and c:IsAbleToRemoveAsCost()
end
function s.hopefiler(c)
    return (c:IsCode(84013237) or c:IsCode(84124261)) and c:GetOverlayCount() > 0
end
function s.zspfilter(c, e, tp)
    return not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.filterno(c, e, tp, tc)
    return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ)
end

-- Gods
function s.DGDfiler(c, tp)
    return c:IsCode(10000020) and c:IsFaceup() and c:IsRace(RACE_CREATORGOD) and
               Duel.CheckReleaseGroup(tp, s.DGDfiler2, 1, nil, c, tp, c:GetTurnID())
end
function s.DGDfiler2(c, tc1, tp, TID)
    local g = Group.FromCards(tc1, c)
    return c:IsCode(10000000) and c:IsFaceup() and c ~= tc1 and c:IsRace(RACE_CREATORGOD) and
               Duel.CheckReleaseGroup(tp, s.DGDfiler3, 1, nil, g, tp, TID)
end
function s.DGDfiler3(c, g, tp, TID)
    local ag = g
    if ag:IsContains(c) then
        return false
    end
    ag:AddCard(c)
    return c:IsCode(10000010) and c:IsFaceup() and
               Duel.GetLocationCountFromEx(tp, tp, ag, TYPE_FUSION) > 0 and c:IsRace(RACE_CREATORGOD)
end
-- Hope
function s.DDPfiler(c, qt, tp)
    return Duel.GetMatchingGroupCount(Card.IsCode, tp, 0x13 + LOCATION_REMOVED, 0, nil, c:GetCode()) < qt
end
function s.DDCfiler(c)
    return c:IsSetCard(0x7f) and c:IsSetCard(0x1048)
end

