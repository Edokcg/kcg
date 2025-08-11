local s, id = GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(12744567,0))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetTarget(s.mtarget)
	e9:SetOperation(s.moperation)
	c:RegisterEffect(e9)

	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(s.mtarget1)
	e10:SetOperation(s.moperation1)
	c:RegisterEffect(e10)

	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(s.mtarget2)
	e11:SetOperation(s.moperation2)
	c:RegisterEffect(e11)

	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetRange(LOCATION_SZONE)
	-- e2:SetTargetRange(LOCATION_MZONE,0)
	-- e2:SetCode(EFFECT_ADD_TYPE)
	-- e2:SetValue(TYPE_TOON)
	-- -- c:RegisterEffect(e2)

	-- local e4=Effect.CreateEffect(c)
	-- e4:SetType(EFFECT_TYPE_FIELD)
	-- e4:SetRange(LOCATION_SZONE)
	-- e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	-- e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	-- e4:SetTarget(s.toontarget)
	-- e4:SetValue(s.indes)
	-- c:RegisterEffect(e4)
	-- local e5=e4:Clone()
	-- e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	-- c:RegisterEffect(e5)
	-- local e6=Effect.CreateEffect(c)
	-- e6:SetType(EFFECT_TYPE_FIELD)
	-- e6:SetRange(LOCATION_SZONE)
	-- e6:SetTargetRange(LOCATION_MZONE,0)
	-- e6:SetTarget(s.toontarget)
	-- e6:SetCondition(s.dircon)
	-- e6:SetCode(EFFECT_DIRECT_ATTACK)
	-- c:RegisterEffect(e6)
	
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e8)
end
s.list={[CARD_ANCIENT_GEAR_GOLEM]=7171149,
        [78658564]=15270885,
        [10189126]=16392422,
	    [CARD_DARK_MAGICIAN]=21296502,
        [81480460]=28112535,
		[5405694]=28711704,
		[CARD_BLUEEYES_W_DRAGON]=53183600,
		[CARD_REDEYES_B_DRAGON]=31733941,
		[2964201]=38369349,
		[69140098]=42386471,
		[CARD_BUSTER_BLADER]=61190918,
		[CARD_HARPIE_LADY]=64116319,
		[65570596]=65458948,
		[11384280]=79875176,
		[CARD_CYBER_DRAGON]=83629030,
		[CARD_DARK_MAGICIAN_GIRL]=90960358,
		[CARD_SUMMONED_SKULL]=91842653}
--------------------------------------------------------------------------------------------------
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
---------------------------------------------------------------------------------------------
function s.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_TOON) and c:IsFaceup()
end
function s.mtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,20,nil)
end
function s.moperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,tc)
	end end
end

function s.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.mtarget1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetOverlayGroup()
	local count=0
	local tc=g:GetFirst()
	while tc do
		if s.filter2(tc,e,tp) then
			count=count+1
		end
		tc=g:GetNext()
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and count>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function s.moperation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:FilterSelect(tp,s.filter2,1,math.min(ft,#g),nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
----------------------------------------------
function s.filter3(c)
	return not c:IsType(TYPE_TOON) and not c:IsSetCard(0x62) and c:IsFaceup()
end
function s.mtarget2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter3,tp,LOCATION_MZONE,0,1,20,nil)
end
function s.moperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(g) do
        if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
            local ss={tc:GetOriginalSetCard()}
            local addset=false
            if #ss>3 then
                addset=true
            else
                table.insert(ss,0x62)
            end
            local type=tc:GetOriginalType()
            local lv=tc:GetOriginalLevel()
            local code=tc:GetOriginalCode()
            local acode=tc:GetOriginalAlias()
            local effcode=tc:GetOriginalCode()
            local ttcode=0
            local tcode=s.list[tc:GetCode()]
            local rrealcode,orcode,rrealalias=tc:GetRealCode()
			if rrealcode>0 then 
				code=orcode
				acode=orcode
				effcode=0
			end
			if rrealcode>0 then
				tc:SetEntityCode(code,nil,ss,TYPE_MONSTER|TYPE_EFFECT|TYPE_TOON,nil,nil,nil,nil,nil,nil,nil,nil,false,838,effcode,838,tc)
				local te1={tc:GetFieldEffect()}
				local te2={tc:GetTriggerEffect()}
				for _,te in ipairs(te1) do
					if te:GetOwner()==tc then
						local te2=te:Clone()
						if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
							local prop=te:GetProperty()
							te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
						end
						tc:RegisterEffect(te2,true)
						te:Reset()
					end
				end
				for _,te in ipairs(te2) do
					if te:GetOwner()==tc then
						local te2=te:Clone()
						if te:IsHasProperty(EFFECT_FLAG_CLIENT_HINT) then
							local prop=te:GetProperty()
							te2:SetProperty(prop&~EFFECT_FLAG_CLIENT_HINT)
						end
						tc:RegisterEffect(te2,true)
						te:Reset()
					end
				end
			else
				tc:SetEntityCode(code,nil,ss,TYPE_MONSTER|TYPE_EFFECT|TYPE_TOON,nil,nil,nil,nil,nil,nil,nil,nil,true,838,effcode,838)
			end
			if addset then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_ADD_SETCODE)
				e1:SetValue(0x62)
				tc:RegisterEffect(e1)
			end
			aux.CopyCardTable(tc,tc,false,"listed_names",15259703)
            local e4=Effect.CreateEffect(tc)
            e4:SetType(EFFECT_TYPE_SINGLE)
            e4:SetDescription(aux.Stringid(838,4),true,0,0,0,0,0,true)
            e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
            e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
            e4:SetValue(s.indes)
            local e5=e4:Clone()
            e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
            e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
            local e6=Effect.CreateEffect(tc)
            e6:SetDescription(aux.Stringid(838,5),true,0,0,0,0,0,true)
            e6:SetType(EFFECT_TYPE_SINGLE)
            e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
            e6:SetCondition(s.dircon)
            e6:SetCode(EFFECT_DIRECT_ATTACK)
            local e7=Effect.CreateEffect(tc)
            e7:SetDescription(aux.Stringid(838,6),true,0,0,0,0,0,true)
            e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
            e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e7:SetRange(LOCATION_MZONE)
            e7:SetCode(EVENT_LEAVE_FIELD)
            e7:SetCondition(s.sdescon)
            e7:SetOperation(s.sdesop)
            tc:RegisterEffect(e7,true)
            tc:RegisterEffect(e6,true)
            tc:RegisterEffect(e5,true)
            tc:RegisterEffect(e4,true)
            
            if bit.band(type,TYPE_RITUAL)~=0 then
                local e1=Effect.CreateEffect(tc)
                e1:SetDescription(aux.Stringid(838,0),true,0,0,0,0,0,true)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_SPSUMMON_PROC)
                e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
                e1:SetRange(LOCATION_HAND)
                e1:SetCondition(s.spconr)
                e1:SetTarget(s.sptgr)
                e1:SetOperation(s.spopr)
                tc:RegisterEffect(e1,true)
            end
            if bit.band(type,TYPE_NORMAL)~=0 then
                local e1=Effect.CreateEffect(tc)
                e1:SetType(EFFECT_TYPE_FIELD)
                e1:SetCode(EFFECT_SPSUMMON_PROC)
                e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
                e1:SetRange(LOCATION_HAND)
                if lv<5 then
                    e1:SetDescription(aux.Stringid(838,1),true,0,0,0,0,0,true)
                    e1:SetCondition(s.spcon0)
                    e1:SetTarget(s.sptg0)
                end
                if lv>4 and lv<7 then
                    e1:SetDescription(aux.Stringid(838,2),true,0,0,0,0,0,true)
                    e1:SetCondition(s.spcon1)
                    e1:SetTarget(s.sptg1)
                    e1:SetOperation(s.spopn)
                end
                if lv>6 then
                    e1:SetDescription(aux.Stringid(838,3),true,0,0,0,0,0,true)
                    e1:SetCondition(s.spcon2)
                    e1:SetTarget(s.sptg2)
                    e1:SetOperation(s.spopn)
                end
                tc:RegisterEffect(e1,true)
            end
            if tcode then
				tc:SetCardData(1, tcode)
			end
        end
    end
end

function s.spfilterr(c)
	return c:IsMonster() and c:IsType(TYPE_TOON) and c:HasLevel() and c:IsLevelAbove(1) and c:IsReleasable()
end
function s.rescon(sg,e,tp,mg)
	if #sg>1 then
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetLevel)>=e:GetOwner():GetOriginalLevel() and not sg:IsExists(Card.IsLevelAbove,1,nil,8)
	else
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetLevel)>=e:GetOwner():GetOriginalLevel()
	end
end
function s.spconr(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilterr,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	return aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,0)
end
function s.breakcon(sg,e,tp,mg)
	return sg:GetSum(Card.GetLevel)>=8
end
function s.sptgr(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilterr,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler())
	local mg=aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,1,tp,HINTMSG_RELEASE,s.breakcon,s.breakcon,true)
	if #mg>0 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.spopr(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.spcon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.sptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spcon1(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),aux.TRUE,1,false,1,true,c,c:GetControler(),nil,false,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spcon2(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),aux.TRUE,2,false,2,true,c,c:GetControler(),nil,false,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,2,2,false,true,true,c,nil,nil,false,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spopn(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.toontarget(e,c)
	return c:IsType(TYPE_TOON)
end
function s.indes(e,c)
	return not c or not c:IsType(TYPE_TOON)
end

function s.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function s.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(s.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end

function s.sfilter(c)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==15259703 and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.sdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.sfilter,1,nil)
end
function s.sdesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end