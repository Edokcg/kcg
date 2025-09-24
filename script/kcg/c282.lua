-- The Claw of Hermos
local s, id = GetID()
function s.initial_effect(c)
    s.efflist={}

    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetDescription(aux.Stringid(44,0))
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(280,0))
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.atarget)
	e2:SetOperation(s.aactivate)
	c:RegisterEffect(e2)
end
s.list = {
    [25652259] = 289,
    [74677422] = 288,
    [71625222] = 170000195,
    [110000110] = 290,
    [30860696] = 291
}

function s.filter(c, e, tp)
    return (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
    and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToGrave()
    and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
    and not c:IsSetCard(0xa1) and not c:IsSetCard(0xa0)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return (Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 and e:GetHandler():IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp, LOCATION_SZONE)>1)
        and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler())
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local c=e:GetHandler()
    if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) or not Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler()) then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FMATERIAL)
    local rg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    if #rg<1 then return end
    local gc=rg:GetFirst()
    if gc:IsFacedown() then Duel.ConfirmCards(tp, gc) end
    local ttcode=0
    local ocode=gc:GetOriginalCode()
    local acode=gc:GetOriginalAlias()
    local tcode=s.list[acode]
    if tcode then 
		ttcode=tcode
	else
		ttcode=44
	end
    local tc=Duel.CreateToken(tp,ttcode,nil,nil,nil,nil,nil,nil)
    local fg=rg
	fg:AddCard(c)
    if Duel.SendtoDeck(tc,tp,0,REASON_RULE+REASON_EFFECT)>0 then
        tc:SetMaterial(fg)
        Duel.SendtoGrave(fg, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
        Duel.BreakEffect()
        if tc:IsCode(44) then
            local ss={gc:GetOriginalSetCard()}
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0xa1)
            end
            local rrealcode,orcode,rrealalias=gc:GetRealCode()
            if rrealcode>0 then 
                ocode=orcode
                acode=orcode
            end
            if rrealcode>0 then
                tc:SetEntityCode(ocode,nil,ss,(gc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION|TYPE_SPELL|TYPE_EQUIP)&~TYPE_NORMAL&~TYPE_SPSUMMON,tc:GetOriginalLevel(),gc:GetOriginalAttribute(),gc:GetOriginalRace(),gc:GetTextAttack(),gc:GetTextDefense(),0,0,0,false,44,44,44,gc)
            else
                tc:SetEntityCode(ocode,nil,ss,(gc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION|TYPE_SPELL|TYPE_EQUIP)&~TYPE_NORMAL&~TYPE_SPSUMMON,tc:GetOriginalLevel(),gc:GetOriginalAttribute(),gc:GetOriginalRace(),gc:GetTextAttack(),gc:GetTextDefense(),0,0,0,false,44,44,44)
            end
            if addset then
                local e1=Effect.CreateEffect(tc)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0xa1)
                tc:RegisterEffect(e1)
            end
            aux.CopyCardTable(gc,tc,false,"listed_names",id,acode)
			local ran=0
			if s.efflist[acode]~=nil then
				ran=s.efflist[acode]
			else
				ran=Duel.GetRandomNumber(0,1)
				s.efflist={[acode]=ran}
			end
            if not gc:IsOriginalType(TYPE_EFFECT) then
                if ran==1 then
                    local e2 = Effect.CreateEffect(tc)
                    e2:SetType(EFFECT_TYPE_EQUIP)
                    e2:SetCode(EFFECT_UPDATE_ATTACK)
                    e2:SetValue(s.value)
                    e2:SetLabelObject(gc)
                    tc:RegisterEffect(e2,true)
                    local e1=Effect.CreateEffect(tc)
                    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetDescription(aux.Stringid(id,4),true)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(id)
                    tc:RegisterEffect(e1)
                else
                    local e2 = Effect.CreateEffect(tc)
                    e2:SetType(EFFECT_TYPE_EQUIP)
                    e2:SetCode(EFFECT_ATTACK_ALL)
                    e2:SetValue(1)
                    e2:SetLabelObject(gc)
                    tc:RegisterEffect(e2,true)
                    local e1=Effect.CreateEffect(tc)
                    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
                    e1:SetDescription(aux.Stringid(id,7),true)
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(id)
                    tc:RegisterEffect(e1)
                end
            else
                if ran==1 then
                    local e3 = Effect.CreateEffect(tc)
                    e3:SetDescription(aux.Stringid(id,5),true)
                    e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                    e3:SetCategory(CATEGORY_DESTROY)
                    e3:SetType(EFFECT_TYPE_QUICK_O)
                    e3:SetCode(EVENT_FREE_CHAIN)
                    e3:SetRange(LOCATION_SZONE)
                    e3:SetCountLimit(1)
                    e3:SetCondition(s.con)
                    e3:SetTarget(s.tar)
                    e3:SetOperation(s.act)
                    tc:RegisterEffect(e3,true)
                else
                    local tec2 = {gc:GetTriggerEffect()}
                    if tec2 then
                        local count=0
                        for _, te in ipairs(tec2) do
                            if (bit.band(te:GetType(), EFFECT_TYPE_QUICK_O) ~= 0 or bit.band(te:GetType(), EFFECT_TYPE_TRIGGER_O) ~= 0 or bit.band(te:GetType(), EFFECT_TYPE_IGNITION) ~= 0)
                            and te:GetOperation() then
                                local te2 = te:Clone()
                                te2:SetOwner(tc)
                                te2:SetCountLimit(1)
                                if te:GetRange() then
                                    te2:SetRange(LOCATION_SZONE)
                                end
                                tc:RegisterEffect(te2, true)
                            end
                        end
                        local e1=Effect.CreateEffect(tc)
                        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
                        e1:SetDescription(aux.Stringid(id,8),true,0,0,0,0,acode)
                        e1:SetType(EFFECT_TYPE_SINGLE)
                        e1:SetCode(id)
                        tc:RegisterEffect(e1)
                    end
                end
            end
            local e1=Effect.CreateEffect(tc)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_DISABLE)
            tc:RegisterEffect(e1)
        else
            tc:SetEntityCode(ttcode,nil,nil,(tc:GetOriginalType()|TYPE_EFFECT|TYPE_FUSION|TYPE_SPELL|TYPE_EQUIP)&~TYPE_NORMAL&~TYPE_SPSUMMON,nil,nil,nil,nil,nil,nil,nil,nil,false,ttcode,ttcode,44,false,true)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local et=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,gc):GetFirst()
        Duel.Equip(tp,tc,et)
        tc:CompleteProcedure()
        -- Equip limit
        local e2 = Effect.CreateEffect(tc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EQUIP_LIMIT)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetValue(Auxiliary.EquipLimit(nil))
        tc:RegisterEffect(e2)
    end
end
function s.costrand(ran2)
	if ran2==1 then return s.discost
	elseif ran2==2 then return s.discost2 
    else return s.descost end
end

function s.value(e, c)
    return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,e)*500+1000
end
function s.atkfilter(c, e)
    local gc=e:GetLabelObject()
    return c:IsRace(gc:GetRace()) and c:IsFaceup()
end

function s.con(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler():GetEquipTarget()
    local at = c:GetBattleTarget()
    return at and at:IsFaceup() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.tar(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    end
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0, nil)
end
function s.act(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsFaceup() then
        return
    end
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    Duel.Destroy(g, REASON_EFFECT)
end


function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,0,1,c)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_DISCARD|REASON_COST)
	g:DeleteGroup()
end


function s.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=(Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 and e:GetHandler():IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp, LOCATION_SZONE)>1)
        and Duel.IsPlayerCanSpecialSummon(tp,SUMMON_TYPE_FUSION,POS_FACEUP,tp,e:GetHandler())
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(44,0)},
		{b2,aux.Stringid(id,2)})
    if op==1 then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_FUSION_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
	    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    elseif op==2 then
        e:SetCategory(CATEGORY_SEARCH)
        Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end
	Duel.SetTargetParam(op)
end
function s.aactivate(e,tp,eg,ep,ev,re,r,rp)
    local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if op==1 then
		s.activate(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
        local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
        if #g>0 then
            local tc=g:GetFirst()
            if not Duel.Equip(tp, tc, c) then
                return
            end
            -- Equip limit
            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_EQUIP_LIMIT)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetValue(Auxiliary.EquipLimit(nil))
            tc:RegisterEffect(e2)
            local e3 = Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_EQUIP)
            e3:SetCode(EFFECT_UPDATE_ATTACK)
            e3:SetValue(1000)
            tc:RegisterEffect(e3)
            Duel.ConfirmCards(1-tp,g)
        else
            Duel.GoatConfirm(tp,LOCATION_DECK)
        end
	end
end