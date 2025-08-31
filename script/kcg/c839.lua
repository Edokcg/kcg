--トゥーン・フリップ
local s,id=GetID()
function s.initial_effect(c)
	--Reveal 3 toon monsters from deck, special summon 1 of them
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
s.listed_names={15259703}
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
        
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,15259703),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsPublic()
end
function s.spfilter2(c,e,tp)
	return c:IsMonster() and c:IsType(TYPE_TOON) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsPublic()
end
function s.filter2(c)
	return c:IsMonster() and not c:IsType(TYPE_TOON) and not c:IsSetCard(0x62)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rvg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rvg:GetClassCount(Card.GetCode)>=3 or rvg:GetClassCount(Card.GetRealCode)>=3)
        and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local rvg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (rvg:GetClassCount(Card.GetCode)>=3 or rvg:GetClassCount(Card.GetRealCode)>=3) 
    and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ag=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,3,3,nil)
    if #ag~=3 then return end
    for tc in aux.Next(ag) do
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
        local ttcode=0
		local piccode=0
		local tcode=tc:GetCode()
		local rrealcode,orcode,rrealalias=tc:GetRealCode()
		if rrealcode>0 then 
			code=orcode
			acode=orcode
			tcode=rrealalias
		end
		if s.list[tcode] then piccode=s.list[tcode] end
		if rrealcode>0 then
			tc:SetEntityCode(code,nil,piccode,ss,TYPE_MONSTER|TYPE_EFFECT|TYPE_TOON,nil,nil,nil,nil,nil,nil,nil,nil,false,838,0,838,tc)
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
			tc:SetEntityCode(code,nil,piccode,ss,TYPE_MONSTER|TYPE_EFFECT|TYPE_TOON,nil,nil,nil,nil,nil,nil,nil,nil,true,838,0,838)
		end
		if addset then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x62)
			tc:RegisterEffect(e1,true)
		end
		aux.CopyCardTable(tc,tc,false,"listed_names",15259703)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetDescription(aux.Stringid(838,4),true,0,0,0,0,0,true)
		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e4:SetValue(s.indes)
		local e5=e4:Clone()
		e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(838,5),true,0,0,0,0,0,true)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e6:SetCondition(s.dircon)
		e6:SetCode(EFFECT_DIRECT_ATTACK)
		local e7=Effect.CreateEffect(c)
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
			local e1=Effect.CreateEffect(c)
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
			local e1=Effect.CreateEffect(c)
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
	end
    Duel.ConfirmCards(1-tp,ag)
	local rvg2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
    if #rvg2<3 then return end
	local rg=aux.SelectUnselectGroup(rvg2,e,tp,3,3,aux.dpcheck(Card.GetOriginalCode),1,tp,HINTMSG_CONFIRM)
	Duel.ConfirmCards(1-tp,rg)
	local tg=rg:RandomSelect(1-tp,1)
	local tc=tg:GetFirst()
	if tc and tc:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
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