-- CXyz Barian, the King of Wishes
local s, id = GetID()
function s.initial_effect(c)
	-- xyz summon
	c:EnableReviveLimit()
	aux.EnableCheckRankUp(c,nil,nil,67926903)

	-- special summon
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(87997872, 0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL + EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)

	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DAMAGE_CAL + EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.con2)
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)

	-- atk
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)

	local e1 = Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(511001363)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s, function()
		local ge = Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetCondition(s.con)
		ge:SetOperation(s.op)
		Duel.RegisterEffect(ge, 0)
	end)

	--copy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.copycost2)
	e7:SetOperation(s.copyop2)
	e7:SetLabel(RESET_EVENT+RESETS_STANDARD)
    local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_RANKUP_EFFECT)
	e02:SetLabelObject(e7)
	c:RegisterEffect(e02)

	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12744567,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(s.lspcon)
	e6:SetTarget(s.lsptg)
	e6:SetOperation(s.lspop)
	c:RegisterEffect(e6)
end
s.listed_names = {38, 67926903}
s.listed_series={0x48}

function s.sfilter(c, tp)
	return c:IsCode(38) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.sfilter, 1, nil, tp)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, true, false) and
				   Duel.IsExistingMatchingCard(s.cfilter2, tp,
					   LOCATION_GRAVE + LOCATION_MZONE, 0, 1, nil, tp,
					   e:GetHandler())
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, LOCATION_EXTRA)
end
function s.cfilter2(c, tp, tc)
	return c:IsCode(67926903) and Duel.GetLocationCountFromEx(tp, tp, Group.FromCards(c), tc) > 0
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	if e:GetHandler():IsRelateToEffect(e) and eg:IsExists(s.sfilter, 1, nil, tp) then
		local g = Duel.SelectMatchingCard(tp, s.cfilter2, tp,
					  LOCATION_GRAVE + LOCATION_MZONE, 0, 1, 1, nil, tp,
					  e:GetHandler())
		if #g<1 then return end
		local ag = g:GetFirst()
		local og = ag:GetOverlayGroup()
		if #og > 0 then
			Duel.Overlay(e:GetHandler(), og)
		end
		e:GetHandler():SetMaterial(g)
		Duel.Overlay(e:GetHandler(), g)
		Duel.SpecialSummon(e:GetHandler(), SUMMON_TYPE_XYZ, tp, tp, true, false, POS_FACEUP)
		e:GetHandler():CompleteProcedure()
	end
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.ofilter, 0, LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED,
				   LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED, 1, nil, tp)
	end
end
function s.ofilter(c, tp)
	local no=c.xyz_number
	return (c:IsControlerCanBeChanged() or c:IsControler(tp)) and not c:IsType(TYPE_TOKEN) and
			   (no and no >= 101 and no <= 107 and c:IsSetCard(0x48))
end
function s.spop2(e, tp, eg, ep, ev, re, r, rp)
	if e:GetHandler():IsRelateToEffect(e) and
		Duel.IsExistingMatchingCard(s.ofilter, 0, LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED,
			LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED, 1, nil, tp) then
		local g = Duel.GetMatchingGroup(s.ofilter, 0, LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED,
					  LOCATION_GRAVE + LOCATION_MZONE + LOCATION_REMOVED, nil, tp)
		if not g then
			return
		end
		for tc in aux.Next(g) do
			local og = tc:GetOverlayGroup()
			if #og > 0 then
				Duel.Overlay(e:GetHandler(), og)
			end
		end
		Duel.Overlay(e:GetHandler(), g)
	end
end

function s.con(e)
	return Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_ALL,LOCATION_ALL,1,e:GetOwner())
end
function s.cfilter(c)
    local chk=false
    local effs={c:GetOwnEffects()}
    for _,te in ipairs(effs) do
        if te:GetCode()==EFFECT_RANKUP_EFFECT then te=te:GetLabelObject() end
        if te:HasDetachCost() then chk=true end
    end
    return chk and c:GetFlagEffect(5110013630)==0
end
function s.op(e)
    local g = Duel.GetMatchingGroup(s.cfilter, 0, LOCATION_ALL, LOCATION_ALL, e:GetOwner())
    for c in aux.Next(g) do
        local effs={c:GetOwnEffects()}
        for _,te in ipairs(effs) do
            if te:GetCode()==EFFECT_RANKUP_EFFECT then te=te:GetLabelObject() end
            if te:HasDetachCost() then
                local resetflag,resetcount=te:GetReset()
                local rm,max,code,flag,hopt=te:GetCountLimit()
                local category = te:GetCategory()
                local prop1,prop2=te:GetProperty()
                local label = te:GetLabel()
                local e1 = Effect.CreateEffect(e:GetOwner())
                if te:GetDescription() then
                    e1:SetDescription(te:GetDescription())
                end
                e1:SetLabelObject(te)
                e1:SetType(EFFECT_TYPE_XMATERIAL+te:GetType()&(~EFFECT_TYPE_SINGLE))
                if te:GetCode()>0 then
                    e1:SetCode(te:GetCode())
                end
                e1:SetCategory(category)
                e1:SetProperty(prop1,prop2)
                if label then
                    e1:SetLabel(label)
                end
                e1:SetCondition(s.copycon)
                e1:SetCost(s.copycost)
                if max > 0 then
                    e1:SetCountLimit(max,{code,hopt}, flag)
                end
                if te:GetTarget() then
                    e1:SetTarget(te:GetTarget())
                end
                if te:GetOperation() then
                    e1:SetOperation(te:GetOperation())
                end
                if resetflag>0 and resetcount>0 then
                    e1:SetReset(resetflag, resetcount)
                elseif resetflag>0 then
                    e1:SetReset(resetflag)
                end
                c:RegisterEffect(e1, true)
            end
            c:RegisterFlagEffect(5110013630,0,0,1)
        end
        if c:GetRealCode()==0 then c:RegisterFlagEffect(5110013630,0,0,1) end
    end
end
function s.copycon(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetLabelObject() then return false end
    local te=e:GetLabelObject()
    local con = te:GetCondition()
    return e:GetHandler():IsHasEffect(511001363) 
    and te:GetOwner():GetFlagEffect(id) == 0 
    and (not con or con(e, tp, eg, ep, ev, re, r, rp))
end
function s.copycost(e, tp, eg, ep, ev, re, r, rp, chk)
    if not e:GetLabelObject() then return false end
    local c=e:GetHandler()
    local te=e:GetLabelObject()
	local tc=te:GetOwner()
    local cost=te:GetCost()
	local a=c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	local b=Duel.CheckLPCost(tp,400)
    local ov=c:GetOverlayGroup()
    if chk == 0 then
        return (a or b) and (cost == nil or cost(e, tp, eg, ep, ev, re, r, rp, 0))
    end
    Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
    local op=Duel.SelectEffect(tp,{a,aux.Stringid(81330115,0)},{b,aux.Stringid(41925941,1)})
	if op==1 then
		Duel.SendtoGrave(tc,REASON_COST)
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,tp,0)
	else
		Duel.PayLPCost(tp,400)
	end
    tc:RegisterFlagEffect(id,RESETS_STANDARD_PHASE_END,0,1)
    if te:GetLabelObject() then
        te:SetLabelObject(te:GetLabelObject())
    end
end

function s.atkval(e, c)
	return c:GetOverlayCount() * 1000
end

function s.lspcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount() > 0
end
function s.lsptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
	local rec = e:GetHandler():GetPreviousAttackOnField()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, rec)
end
function s.lspop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
		local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
		Duel.Recover(p, d, REASON_EFFECT)
	end
end

function s.cfilter2(c)
    return c:GetFlagEffect(id)==0 and c:IsSetCard(0x48) and c:IsType(TYPE_EFFECT)
end
function s.copycost2(e, tp, eg, ep, ev, re, r, rp, chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():FilterCount(s.cfilter2,nil)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
	local sc=c:GetOverlayGroup():FilterSelect(tp,s.cfilter2,1,1,nil,e,tp):GetFirst()
    Duel.SendtoGrave(sc,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	Duel.RaiseEvent(c,EVENT_DETACH_MATERIAL,e,REASON_EFFECT,tp,tp,0)
    e:SetLabelObject(sc)
end
function s.copyop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc then
		local code=tc:GetOriginalCode()
		--This card's name becomes the target's name
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetLabel(tp)
		e1:SetReset(RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		c:RegisterEffect(e1)
		--Replace this card's effect with that monster's original effect
		local cid=c:CopyEffect(code,RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		--Reset the effects manually at the End Phase of the opponent's next turn
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,4))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(s.resetcon)
		e2:SetOperation(s.resettop)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetReset(RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN)
		c:RegisterEffect(e2)
	end
end
function s.resetcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabelObject():GetLabel()
	return Duel.IsTurnPlayer(1-p)
end
function s.resettop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
