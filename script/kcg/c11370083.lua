--Seventh Arrival
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={0x48,0x177}

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
	if chk==0 then return #sg>0 and sg:FilterCount(Card.IsReleasable,nil)==#sg end
	local ct=Duel.Release(sg,REASON_COST)
	Duel.SetTargetParam(ct+1)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
		if e:GetLabel()==1 then ft=Duel.GetMZoneCount(tp,sg) end
		e:SetLabel(0)
		return ft>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,300)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg<1 then return end
	local tc=sg:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.atfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,tc)
	if #g>0 and count>0 and not tc:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=g:Select(tp,1,count,nil)
		if #mg>0 then
			Duel.HintSelection(mg)
			Duel.BreakEffect()
			Duel.Overlay(tc,mg)
		end
	end

    if tc:GetFlagEffect(id)==0 then
        tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
        local tec={tc:GetFieldEffect()}
        for _, te in ipairs(tec) do
            if te:GetCode() == EFFECT_MARKER_DETACH_XMAT and te:GetLabelObject() then
                local tee = te:Clone()
                local te2 = te:GetLabelObject()
                local tee2 = te2:Clone()
                te:Reset()
                te2:Reset()
                local cond = te2:GetCondition()
                tee2:SetCondition(function(ae,...) return (not cond or cond(ae,...)) and ae:GetHandler():GetFlagEffect(id) == 0 end)
                tc:RegisterEffect(tee2, true)
                tee:SetLabelObject(tee2)
                tc:RegisterEffect(tee, true)
            end
            if te:GetCode() == 511001363 then
                local tee = te:Clone()
                te:Reset()
                local cond = tee:GetCondition()
                tee:SetCondition(function(ae,...) return (not cond or cond(ae,...)) and ae:GetHandler():GetFlagEffect(id) == 0 end)
                tc:RegisterEffect(tee, true)
            end
        end
    end

	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.damop)
	Duel.RegisterEffect(e2,tp)
end
function s.atfilter(c)
	local no=c.xyz_number
	return no and no>=101 and no<=107 and c:IsSetCard(SET_NUMBER) and c:IsFaceup()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*300,REASON_EFFECT,true)
	Duel.Damage(1-tp,Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*300,REASON_EFFECT,true)
	Duel.RDComplete()
end

function s.thfilter(c)
	return c:IsSetCard(0x177) and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		--act qp in hand
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e0:SetRange(LOCATION_HAND)
		e0:SetTargetRange(LOCATION_HAND,0)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e0)
	end
end