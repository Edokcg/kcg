--機皇帝ワイゼル∞-S・アブソープション
--Meklord Emperor Wisel - Synchro Absorption
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Must be special summoned by its own method
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)

	--Special summon itself from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--Make 1 of opponen'ts monsters unable to attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	--Negate activation
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.negcon)
	e4:SetCost(Cost.SelfTribute)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
    
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(s.operation)
	c:RegisterEffect(e5)
	--defup
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(s.operation1)
	c:RegisterEffect(e6)
    
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_ATTACK)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(s.atkfilter)
	c:RegisterEffect(e9)
end
s.listed_series={SET_MEKLORD,0x560,0x549,0x524}

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end
function s.cfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(SET_MEKLORD) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(100000051,100000052,100000053,100000054,100000048,100000049,100000047,100000309) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(sg,e,tp,mg)
	return (sg:IsExists(Card.IsCode,1,nil,100000051) or sg:IsExists(Card.IsCode,1,nil,100000049)) and (sg:IsExists(Card.IsCode,1,nil,100000052) or sg:IsExists(Card.IsCode,1,nil,100000049) or sg:IsExists(Card.IsCode,1,nil,100000309)) and (sg:IsExists(Card.IsCode,1,nil,100000053) or sg:IsExists(Card.IsCode,1,nil,100000047)) and sg:IsExists(Card.IsCode,1,nil,100000054)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~0 then
		c:CompleteProcedure()
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 or (ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
        Duel.BreakEffect()
        local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
        if not s.rescon(sg) then return end
        local spg=aux.SelectUnselectGroup(sg,e,tp,4,4,s.rescon,1,tp,HINTMSG_SPSUMMON)
        if #sg>0 then
            Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end

function s.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and (chkc:IsFaceup() or s.eqfilter(chkc)) end
	local b1=Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(s.eqfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    else
        e:SetCategory(CATEGORY_EQUIP)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	    local g=Duel.SelectTarget(tp,s.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	end
	Duel.SetTargetParam(op)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        if op==1 then
            --Cannot attack
            local e1=Effect.CreateEffect(c)
            e1:SetDescription(3206)
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_CANNOT_ATTACK)
            e1:SetReset(RESETS_STANDARD_PHASE_END)
            tc:RegisterEffect(e1)
        else
            if c:IsFaceup() and c:IsRelateToEffect(e) then
                local atk=tc:GetTextAttack()
                if atk<0 then atk=0 end
                if not Duel.Equip(tp,tc,c,false) then return end
                --Add Equip limit
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetReset(RESET_EVENT+0x1fe0000)
                e1:SetValue(s.eqlimit)
                tc:RegisterEffect(e1)
            else Duel.SendtoGrave(tc,REASON_EFFECT)
            end
        end
    end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and (tc+tg:FilterCount(Card.IsOnField,nil)-#tg)>0
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.spfilter2(c,e,tp)
	return c:IsCode(68140974,100000051,100000052,100000053,100000054,100000048,100000049,100000047,100000309) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon2(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,68140974) and (sg:IsExists(Card.IsCode,1,nil,100000051) or sg:IsExists(Card.IsCode,1,nil,100000049)) and (sg:IsExists(Card.IsCode,1,nil,100000052) or sg:IsExists(Card.IsCode,1,nil,100000049) or sg:IsExists(Card.IsCode,1,nil,100000309)) and (sg:IsExists(Card.IsCode,1,nil,100000053) or sg:IsExists(Card.IsCode,1,nil,100000047)) and sg:IsExists(Card.IsCode,1,nil,100000054)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        if ft<=0 or (ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)) then return end
        Duel.BreakEffect()
        local sg=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil,e,tp)
        if not s.rescon2(sg) then return end
        local spg=aux.SelectUnselectGroup(sg,e,tp,5,5,s.rescon2,1,tp,HINTMSG_SPSUMMON)
        if #sg>0 then
            Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end

function s.filter(c)
	return c:IsFaceup() and (c:IsWisel() or c:IsSkiel() or c:IsGranel()) and not c:IsSetCard(0x3013)
end
function s.eqfilter2(c)
	return c:IsFaceup() 
	--and bit.band(c:GetOriginalType(),TYPE_SYNCHRO)~=0
end
function s.operation1(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,c)
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end

	local g=e:GetHandler():GetEquipGroup():Filter(s.eqfilter2,nil)
	local tatk=0
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		local atk=tc:GetTextAttack()
		tatk=tatk+atk
		tc=g:GetNext() end
	end

	return wup+tatk
end
function s.operation(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,c)
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end
	return wup
end

function s.atkfilter(e,c)
	return (c:IsWisel() or c:IsSkiel() or c:IsGranel()) and not c:IsSetCard(0x3013) and c~=e:GetHandler() 
end